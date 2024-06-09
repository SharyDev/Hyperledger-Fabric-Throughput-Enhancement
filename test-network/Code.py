#include <stdio.h>
#include <stdlib.h>
#include <oqs/oqs.h>

int main() {
    OQS_STATUS status;
    OQS_keyencap *kem;
    const char *algorithm_name = "Kyber1024";
    uint8_t *public_key = NULL;
    size_t public_key_length;
    uint8_t *secret_key = NULL;
    size_t secret_key_length;

    // Initialize liboqs
    status = OQS_keyencap_new(algorithm_name, &kem);
    if (status != OQS_SUCCESS) {
        fprintf(stderr, "Error initializing liboqs\n");
        exit(EXIT_FAILURE);
    }

    // Generate key pair
    status = OQS_keyencap_keypair(kem, &public_key, &public_key_length, &secret_key, &secret_key_length);
    if (status != OQS_SUCCESS) {
        fprintf(stderr, "Error generating key pair\n");
        exit(EXIT_FAILURE);
    }

    // Save keys to files or integrate into MSP

    // Clean up
    OQS_keyencap_free(kem);
    free(public_key);
    free(secret_key);

    return 0;
}

