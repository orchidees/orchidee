// Mex function for 'countAllValues'
// 
// Given a input integer matrix A and a max xount integer m,
// count in each column of A the number of occurences of each
// integer between 1 and m. If A is a nxp matrix, the output is
// a mxp matrix
//

#include "mex.h"
#include "stdio.h"


void countAllValues(double *R,
		    double *K,
		    const int maxCount,
		    const int Ncolumns,
		    const int Nlines)
{
    int i, j, pos_R, pos_K;
    
    // Initialize output matrix
    for (i=0;i<Ncolumns;i++)
    {
        for (j=0;j<maxCount;j++)
        {
            pos_R = maxCount*i+j;
            R[pos_R] = 0;;
        }
    }
    
    // Count values
    for (i=0;i<Ncolumns;i++)
    {
        for (j=0;j<Nlines;j++)
        {
            pos_K = Nlines*i+j;
            
            if (K[pos_K] > maxCount)
                mexErrMsgTxt("Error: Max count number has a too low value.");
            
            pos_R = maxCount*i+K[pos_K]-1;
            R[pos_R] = R[pos_R]+1;
        }
    }
}




void mexFunction(int nlhs,
		 mxArray *plhs[], 
		 int nrhs,
		 const mxArray *prhs[])
{
  double *K;
  double *R;
  double *maxCount_ptr;
  int maxCount, Nlines, Ncolumns;
  int m0, n0, m1, n1;

  // Check input args
  if (nrhs != 2)
    mexErrMsgTxt("Error: Wrong number of input arguments.");

  // Check put args
  if (nlhs != 1)
    mexErrMsgTxt("Error: Wrong number of output arguments.");
  
  // Get input args (as pointers)
  K = mxGetPr(prhs[0]);
  maxCount_ptr = mxGetPr(prhs[1]);

  // Get input args sizes
  m0 = mxGetM(prhs[0]);
  m1 = mxGetM(prhs[1]);
  n0 = mxGetN(prhs[0]);
  n1 = mxGetN(prhs[1]);
  
  // Check input vectors sizes
  if ((m1 != 1) || (n1 != 1))
    mexErrMsgTxt("Error: Max count should be an integer.");

  if (m0 == 0)
    mexErrMsgTxt("Error: Input matrix is empty.");

  // Get max count and matrisx size
  maxCount = maxCount_ptr[0];
  Nlines = m0;
  Ncolumns = n0;

  // Allow memory for output
  R = (double *) mxMalloc(Ncolumns*maxCount*sizeof(double));

  // Do the real job
  countAllValues(R,K,maxCount,Ncolumns,Nlines);

  // Create an mxArray for the output
  plhs[0] = mxCreateDoubleMatrix(maxCount,Ncolumns,mxREAL);

  // Assign the data array to the output array
  mxSetPr(plhs[0],R);
}
