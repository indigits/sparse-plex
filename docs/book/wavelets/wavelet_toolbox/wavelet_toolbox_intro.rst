Introduction
==================

.. highlight:: matlab

This section is a quick review of wavelet toolbox in MATLAB.

.. rubric:: Wavelet families

The toolbox supports a number of wavelet families::

    >> waveletfamilies('f')
    ===================================
    Haar                    haar           
    Daubechies              db             
    Symlets                 sym            
    Coiflets                coif           
    BiorSplines             bior           
    ReverseBior             rbio           
    Meyer                   meyr           
    DMeyer                  dmey           
    Gaussian                gaus           
    Mexican_hat             mexh           
    Morlet                  morl           
    Complex Gaussian        cgau           
    Shannon                 shan           
    Frequency B-Spline      fbsp           
    Complex Morlet          cmor           
    Fejer-Korovkin          fk             
    ===================================

Following command shows how to get the list of wavelets 
in each of the families::


    >> waveletfamilies('n')
    ===================================         
    Haar                    haar                    
    ===================================         
    Daubechies              db                      
    ------------------------------              
    db1 db2 db3 db4                             
    db5 db6 db7 db8                             
    db9 db10    db**                                  
    ===================================         
    Symlets                 sym                     
    ------------------------------              
    sym2    sym3    sym4    sym5                            
    sym6    sym7    sym8    sym**                          
    ===================================         
    Coiflets                coif                    
    ------------------------------              
    coif1   coif2   coif3   coif4                       
    coif5                                         
    ===================================         
    BiorSplines             bior                    
    ------------------------------              
    bior1.1 bior1.3 bior1.5 bior2.2             
    bior2.4 bior2.6 bior2.8 bior3.1             
    bior3.3 bior3.5 bior3.7 bior3.9             
    bior4.4 bior5.5 bior6.8                     
    ===================================         
    ReverseBior             rbio                    
    ------------------------------              
    rbio1.1 rbio1.3 rbio1.5 rbio2.2             
    rbio2.4 rbio2.6 rbio2.8 rbio3.1             
    rbio3.3 rbio3.5 rbio3.7 rbio3.9             
    rbio4.4 rbio5.5 rbio6.8                     
    ===================================         
    Meyer                   meyr                    
    ===================================         
    DMeyer                  dmey                    
    ===================================         
    Gaussian                gaus                    
    ------------------------------              
    gaus1   gaus2   gaus3   gaus4                       
    gaus5   gaus6   gaus7   gaus8                       
    ===================================         
    Mexican_hat             mexh                    
    ===================================         
    Morlet                  morl                    
    ===================================         
    Complex Gaussian        cgau                    
    ------------------------------              
    cgau1   cgau2   cgau3   cgau4                       
    cgau5   cgau6   cgau7   cgau8                       
    ===================================         
    Shannon                 shan                    
    ------------------------------              
    shan1-1.5   shan1-1 shan1-0.5   shan1-0.1         
    shan2-3 shan**                               
    ===================================         
    Frequency B-Spline      fbsp                    
    ------------------------------              
    fbsp1-1-1.5 fbsp1-1-1   fbsp1-1-0.5 fbsp2-1-1   
    fbsp2-1-0.5 fbsp2-1-0.1 fbsp**               
    ===================================         
    Complex Morlet          cmor                    
    ------------------------------              
    cmor1-1.5   cmor1-1 cmor1-0.5   cmor1-1         
    cmor1-0.5   cmor1-0.1   cmor**                   
    ===================================         
    Fejer-Korovkin          fk                      
    ------------------------------              
    fk4 fk6 fk8 fk14                               
    fk18    fk22                                      
    ===================================         
     