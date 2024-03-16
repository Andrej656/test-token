



;; Define constants for contract owner and error codes
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))

;; Declare a non-fungible token named 'blockcity'
(define-non-fungible-token blockcity uint)

;; Variable to keep track of the last token ID
(define-data-var last-token-id uint u0)

;; Read-only function to get the last token ID
(define-read-only (get-last-token-id)
  (ok (var-get last-token-id))
)

;; Read-only function to get the token URI
;; Placeholder implementation, you can extend this to return actual URIs
(define-read-only (get-token-uri (token-id uint))
  (ok none)
)

;; Read-only function to get the owner of a token
(define-read-only (get-owner (token-id uint))
  (ok (nft-get-owner? blockcity token-id))
)

;; Public function to transfer a token from one owner to another
(define-public (transfer (token-id uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) err-not-token-owner)
    (nft-transfer? blockcity (as-contract-id token-id) sender recipient)
  )
)

;; Public function to mint a new token
(define-public (mint (recipient principal))
  (let
    (
      (token-id (+ (var-get last-token-id) u1))
    )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (try! (nft-mint? blockcity token-id recipient))
    (var-set last-token-id token-id)
    (ok token-id)
  )
)
