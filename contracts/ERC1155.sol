// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @dev ERC-165 식별자: bytes4(keccak256("supportsInterface(bytes4)")) == 0x01ffc9a7
interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

/// @dev ERC-1155 수신 인터페이스
interface IERC1155Receiver {
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4);

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4);
}

/// @dev ERC-1155 인터페이스
interface IERC1155 is IERC165 {
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
    event TransferBatch( address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values );
    event ApprovalForAll(address indexed account, address indexed operator, bool approved);
    event URI(string value, uint256 indexed id);

    function balanceOf(address account, uint256 id) external view returns (uint256);
    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
        external view returns (uint256[] memory);

    function setApprovalForAll(address operator, bool approved) external;
    function isApprovedForAll(address account, address operator) external view returns (bool);

    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
    function safeBatchTransferFrom(
        address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data
    ) external;
}

contract MyERC1155 is IERC1155 {
    // --- 내부 저장 구조 ---
    // token ID → (owner → balance)
    mapping(uint256 => mapping(address => uint256)) private _balances;
    // owner → operator → approved?
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    // supportsInterface
    bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;
    bytes4 private constant _INTERFACE_ID_ERC165  = 0x01ffc9a7;

    // --- ERC-165 지원 ---
    function supportsInterface(bytes4 interfaceId) external pure override returns (bool) {
        return interfaceId == _INTERFACE_ID_ERC1155
            || interfaceId == _INTERFACE_ID_ERC165;
    }

    // --- 조회 함수 ---
    function balanceOf(address account, uint256 id) public view override returns (uint256) {
        require(account != address(0), "ERC1155: zero address");
        return _balances[id][account];
    }

    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
        external view override returns (uint256[] memory)
    {
        require(accounts.length == ids.length, "ERC1155: length mismatch");
        uint256[] memory batchBalances = new uint256[](accounts.length);
        for (uint i = 0; i < accounts.length; i++) {
            batchBalances[i] = balanceOf(accounts[i], ids[i]);
        }
        return batchBalances;
    }

    // --- 승인 관리 ---
    function setApprovalForAll(address operator, bool approved) external override {
        require(msg.sender != operator, "ERC1155: self-approval");
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address account, address operator) external view override returns (bool) {
        return _operatorApprovals[account][operator];
    }

    // --- 전송 함수 ---
    function safeTransferFrom(
        address from, address to, uint256 id, uint256 amount, bytes calldata data
    ) external override {
        require(
            from == msg.sender || _operatorApprovals[from][msg.sender],
            "ERC1155: not owner nor approved"
        );
        require(to != address(0), "ERC1155: zero recipient");

        _beforeTokenTransfer(msg.sender, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);

        // 잔액 조정
        uint256 fromBal = _balances[id][from];
        require(fromBal >= amount, "ERC1155: insufficient balance");
        _balances[id][from] = fromBal - amount;
        _balances[id][to]   += amount;

        emit TransferSingle(msg.sender, from, to, id, amount);

        _doSafeTransferAcceptanceCheck(msg.sender, from, to, id, amount, data);
    }

    function safeBatchTransferFrom(
        address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data
    ) external override {
        require(
            from == msg.sender || _operatorApprovals[from][msg.sender],
            "ERC1155: not owner nor approved"
        );
        require(ids.length == amounts.length, "ERC1155: length mismatch");
        require(to != address(0), "ERC1155: zero recipient");

        _beforeTokenTransfer(msg.sender, from, to, ids, amounts, data);

        for (uint i = 0; i < ids.length; i++) {
            uint id     = ids[i];
            uint amount = amounts[i];

            uint fromBal = _balances[id][from];
            require(fromBal >= amount, "ERC1155: insufficient balance");
            _balances[id][from] = fromBal - amount;
            _balances[id][to]   += amount;
        }

        emit TransferBatch(msg.sender, from, to, ids, amounts);
        _doSafeBatchTransferAcceptanceCheck(msg.sender, from, to, ids, amounts, data);
    }

    // --- 내부 헬퍼 ---
    function _asSingletonArray(uint256 element) private pure returns (uint256[] memory arr) {
        arr = new uint256;
        arr[0] = element;
    }

    // 전송 수신자 검증
    function _doSafeTransferAcceptanceCheck(
        address operator, address from, address to, uint256 id, uint256 amount, bytes calldata data
    ) private {
        if (to.code.length > 0) {
            try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 resp) {
                require(resp == IERC1155Receiver.onERC1155Received.selector,
                    "ERC1155: bad receiver");
            } catch {
                revert("ERC1155: transfer to non-ERC1155Receiver");
            }
        }
    }

    function _doSafeBatchTransferAcceptanceCheck(
        address operator, address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data
    ) private {
        if (to.code.length > 0) {
            try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (bytes4 resp) {
                require(resp == IERC1155Receiver.onERC1155BatchReceived.selector,
                    "ERC1155: bad receiver");
            } catch {
                revert("ERC1155: batch to non-ERC1155Receiver");
            }
        }
    }

    // Hook: 확장 시 오버라이드 가능
    function _beforeTokenTransfer(
        address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data
    ) internal virtual {}

    // --- Mint / Burn (예시) ---
    function _mint(address to, uint256 id, uint256 amount, bytes memory data) internal {
        require(to != address(0), "ERC1155: mint to zero");
        _beforeTokenTransfer(msg.sender, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
        _balances[id][to] += amount;
        emit TransferSingle(msg.sender, address(0), to, id, amount);
        _doSafeTransferAcceptanceCheck(msg.sender, address(0), to, id, amount, data);
    }

    function _mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal {
        require(to != address(0), "ERC1155: mint to zero");
        require(ids.length == amounts.length, "ERC1155: length mismatch");
        _beforeTokenTransfer(msg.sender, address(0), to, ids, amounts, data);
        for (uint i = 0; i < ids.length; i++) {
            _balances[ids[i]][to] += amounts[i];
        }
        emit TransferBatch(msg.sender, address(0), to, ids, amounts);
        _doSafeBatchTransferAcceptanceCheck(msg.sender, address(0), to, ids, amounts, data);
    }

    function _burn(address from, uint256 id, uint256 amount) internal {
        require(from != address(0), "ERC1155: burn from zero");
        _beforeTokenTransfer(msg.sender, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
        uint256 fromBal = _balances[id][from];
        require(fromBal >= amount, "ERC1155: burn too much");
        _balances[id][from] = fromBal - amount;
        emit TransferSingle(msg.sender, from, address(0), id, amount);
    }

    function _burnBatch(address from, uint256[] memory ids, uint256[] memory amounts) internal {
        require(from != address(0), "ERC1155: burn from zero");
        require(ids.length == amounts.length, "ERC1155: length mismatch");
        _beforeTokenTransfer(msg.sender, from, address(0), ids, amounts, "");
        for (uint i = 0; i < ids.length; i++) {
            uint256 id     = ids[i];
            uint256 amount = amounts[i];
            uint256 fromBal = _balances[id][from];
            require(fromBal >= amount, "ERC1155: burn too much");
            _balances[id][from] = fromBal - amount;
        }
        emit TransferBatch(msg.sender, from, address(0), ids, amounts);
    }
}
