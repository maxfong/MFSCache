// This is public domain code originally written by Philip J. Erdelsky
// http://www.alumni.caltech.edu/~pje/
// Originally downloaded from http://www.efgh.com/software/rijndael.txt


#ifndef H__mfs_RIJNDAEL
#define H__mfs_RIJNDAEL

int mfs_rijndaelSetupEncrypt(unsigned long *rk, const unsigned char *key,
  int keybits);
int mfs_rijndaelSetupDecrypt(unsigned long *rk, const unsigned char *key,
  int keybits);
void mfs_rijndaelEncrypt(const unsigned long *rk, int nrounds,
  const unsigned char plaintext[16], unsigned char ciphertext[16]);
void mfs_rijndaelDecrypt(const unsigned long *rk, int nrounds,
  const unsigned char ciphertext[16], unsigned char plaintext[16]);

#define KEYLENGTH(keybits) ((keybits)/8)
#define RKLENGTH(keybits)  ((keybits)/8+28)
#define NROUNDS(keybits)   ((keybits)/32+6)

// If this line is commented out, it will use loops to iterate through chunks. If this
// is uncommented, it will use unrolled loops, which will perform better, but the binary
// will be larger.
//#define FULL_UNROLL
#endif