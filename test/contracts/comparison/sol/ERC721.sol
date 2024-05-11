pragma solidity 0.8.25;

contract ERC721 {
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );

    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    string private _name;

    string private _symbol;

    mapping(uint256 => address) private _owners;

    mapping(address => uint256) private _balances;

    mapping(uint256 => address) private _tokenApprovals;

    mapping(address => mapping(address => bool)) private _operatorApprovals;

    mapping(uint256 => string) private _tokenURIs;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function balanceOf(address owner) public view virtual returns (uint256) {
        if (owner == address(0)) {
            revert("ERC721InvalidOwner(address(0))");
        }
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view virtual returns (address) {
        return _requireOwned(tokenId);
    }

    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        returns (string memory)
    {
        _requireOwned(tokenId);

        return _tokenURIs[tokenId];
    }

    function approve(address to, uint256 tokenId) public virtual {
        _approve(to, tokenId, msg.sender, true);
    }

    function getApproved(uint256 tokenId)
        public
        view
        virtual
        returns (address)
    {
        _requireOwned(tokenId);

        return _getApproved(tokenId);
    }

    function setApprovalForAll(address operator, bool approved) public virtual {
        _setApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address owner, address operator)
        public
        view
        virtual
        returns (bool)
    {
        return _operatorApprovals[owner][operator];
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable {
        _transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual {
        if (to == address(0)) {
            revert("ERC721InvalidReceiver(address(0))");
        }

        address previousOwner = _update(to, tokenId, msg.sender);
        if (previousOwner != from) {
            revert("ERC721IncorrectOwner(from, tokenId, previousOwner)");
        }
    }

    function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
        return _owners[tokenId];
    }

    function _getApproved(uint256 tokenId)
        internal
        view
        virtual
        returns (address)
    {
        return _tokenApprovals[tokenId];
    }

    function _isAuthorized(
        address owner,
        address spender,
        uint256 tokenId
    ) internal view virtual returns (bool) {
        return
            spender != address(0) &&
            (owner == spender ||
                isApprovedForAll(owner, spender) ||
                _getApproved(tokenId) == spender);
    }

    function _checkAuthorized(
        address owner,
        address spender,
        uint256 tokenId
    ) internal view virtual {
        if (!_isAuthorized(owner, spender, tokenId)) {
            if (owner == address(0)) {
                revert("ERC721NonexistentToken(tokenId)");
            } else {
                revert("ERC721InsufficientApproval(spender, tokenId)");
            }
        }
    }

    function _increaseBalance(address account, uint128 value) internal virtual {
        unchecked {
            _balances[account] += value;
        }
    }

    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal virtual returns (address) {
        address from = _ownerOf(tokenId);

        if (auth != address(0)) {
            _checkAuthorized(from, auth, tokenId);
        }

        if (from != address(0)) {
            _approve(address(0), tokenId, address(0), false);

            unchecked {
                _balances[from] -= 1;
            }
        }

        if (to != address(0)) {
            unchecked {
                _balances[to] += 1;
            }
        }

        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);

        return from;
    }

    function _mint(address to, uint256 tokenId) internal {
        if (to == address(0)) {
            revert("ERC721InvalidReceiver(address(0))");
        }
        address previousOwner = _update(to, tokenId, address(0));
        if (previousOwner != address(0)) {
            revert("ERC721InvalidSender(address(0))");
        }
    }

    function _burn(uint256 tokenId) internal {
        address previousOwner = _update(address(0), tokenId, address(0));
        if (previousOwner == address(0)) {
            revert("ERC721NonexistentToken(tokenId)");
        }
    }

    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal {
        if (to == address(0)) {
            revert("ERC721InvalidReceiver(address(0))");
        }
        address previousOwner = _update(to, tokenId, address(0));
        if (previousOwner == address(0)) {
            revert("ERC721NonexistentToken(tokenId)");
        } else if (previousOwner != from) {
            revert("ERC721IncorrectOwner(from, tokenId, previousOwner)");
        }
    }

    function _approve(
        address to,
        uint256 tokenId,
        address auth,
        bool emitEvent
    ) internal virtual {
        address owner = _requireOwned(tokenId);

        if (
            auth != address(0) &&
            owner != auth &&
            !isApprovedForAll(owner, auth)
        ) {
            revert("ERC721InvalidApprover(auth)");
        }

        if (emitEvent) {
            emit Approval(owner, to, tokenId);
        }

        _tokenApprovals[tokenId] = to;
    }

    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        if (operator == address(0)) {
            revert("ERC721InvalidOperator(operator)");
        }
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    function _requireOwned(uint256 tokenId) internal view returns (address) {
        address owner = _ownerOf(tokenId);
        if (owner == address(0)) {
            revert("ERC721NonexistentToken(tokenId)");
        }
        return owner;
    }
}
