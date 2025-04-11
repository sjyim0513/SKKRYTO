mapping(uint256 => MainClaimDraft) public mainClaimDrafts;
mapping(uint256 => MainClaim) public mainClaims;

// 메인 클레임 ID → 클러스터 ID 리스트
mapping(uint256 => uint256[]) public mainClaimToClusters;
// 메인 클레임 ID → (특정 클러스터가 소속되어 있는지 여부)
mapping(uint256 => mapping(uint256 => bool)) public isClusterInMainClaim;

// 클러스터 정보
mapping(uint256 => Cluster) public clusters;
// 클러스터 ID → 클레임 ID 리스트
mapping(uint256 => uint256[]) public clusterToClaims;
// 클러스터 ID → (특정 클레임이 소속되어 있는지 여부)
mapping(uint256 => mapping(uint256 => bool)) public isClaimInCluster;

// 클레임 정보
mapping(uint256 => Claim) public claims;
// 클레임 ID → 버전 이력 배열
mapping(uint256 => ClaimVersion[]) public claimVersions;
