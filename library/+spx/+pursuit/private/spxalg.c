#include "spxalg.h"

#define  MAX_LEVELS  300

void quicksort_indices(mwIndex indices[], double data[], mwIndex n) {
  
  long piv, beg[MAX_LEVELS], end[MAX_LEVELS], i=0, L, R, swap ;
  double datapiv;
  
  beg[0]=0;
  end[0]=n;
  
  while (i>=0) {
    
    L=beg[i]; 
    R=end[i]-1;
    
    if (L<R) {
      
      piv=indices[L];
      datapiv=data[L];
      
      while (L<R) 
      {
        while (indices[R]>=piv && L<R) 
          R--;
        if (L<R) {
          indices[L]=indices[R];
          data[L++]=data[R];
        }
        
        while (indices[L]<=piv && L<R) 
          L++;
        if (L<R) { 
          indices[R]=indices[L];
          data[R--]=data[L];
        }
      }
      
      indices[L]=piv;
      data[L]=datapiv;
      
      beg[i+1]=L+1;
      end[i+1]=end[i];
      end[i++]=L;
      
      if (end[i]-beg[i] > end[i-1]-beg[i-1]) {
        swap=beg[i]; beg[i]=beg[i-1]; beg[i-1]=swap;
        swap=end[i]; end[i]=end[i-1]; end[i-1]=swap;
      }
    }
    else {
      i--;
    }
  }
}
