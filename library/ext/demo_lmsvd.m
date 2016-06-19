% Demo script for comparing Matlab SVDS with LMSVD

clc
% problem size
%Asize = input('[m n] = ');
Asize = [1 1]*2000;
m = Asize(1);
n = Asize(2);

nR = 5; pcent = 5;
Ranks = (1:nR)*ceil(pcent/100*min(m,n)/nR);
ferr = @(u,v) norm(u(:)-v(:))/norm(v(:));

% generate random A
tau = rand; 
base = 1 + 0.1*tau; 
d = max(base.^(0:-1:-n+1),eps);
A = randn(m,n)*sparse(1:n,1:n,d);
A = A(randperm(m),randperm(n));

% set options
opts.tol = 1e-8;
opts.maxit = 150;

T1 = zeros(1,nR); E1 = T1; 
T2 = T1; E2 = E1;

for j = 1:nR
    
    r = Ranks(j); k = r + 10;
    fprintf('\n size: [m n r] = [%i %i %i]\n',m,n,r)    
    
    % Matlab svds
    tic; [U1,S1,V1] = svds(A,r,'L',opts);
    t1 = toc; e1 = ferr(U1*S1*V1',A); sv1 = diag(S1);
    fprintf(' svds: res = %16.12e, t = %5.3e\n',e1,t1);
    T1(j) = t1; E1(j) = e1;
     
    % lmsvd
    tic; [U2,S2,V2,Out] = lmsvd(A,r,opts); 
    t2 = toc; e2 = ferr(U2*S2*V2',A); sv2 = diag(S2);
    fprintf('lmsvd: res = %16.12e, t = %5.3e\n',e2,t2);
    T2(j) = t2; E2(j) = e2;
        
end
fprintf('\nSummary: avg-err = %.2e. time ratio: %.2f\n\n',...
    mean(abs(E1-E2)),sum(T1)/sum(T2));

%% plot
close all; scrsz = get(0,'ScreenSize');
figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2])
subplot(121)
svk = Out.svk; bar(svk/svk(1),.01); hold on
plot(1:r,svk(1:r)/svk(1),'bo','MarkerSize',3,'linewidth',2); 
%plot(r+1:k,svk(r+1:k)/svk(1),'bd','MarkerSize',3,'linewidth',2); 
hold off
t_str = sprintf('Singular Values');
title(t_str,'fontsize',14);
xlabel('Number of sv''s','fontsize',14);
set(gca,'fontsize',12);
axis square

subplot(122)
semilogy(Ranks,T1,'rs:',Ranks,T2,'bd:',...
    'MarkerSize',6,'linewidth',2)
t_str = sprintf('Matrix: %i x %i',m,n);
title(t_str,'fontsize',14); 
xlabel('Number of sv''s','fontsize',14);
ylabel('Time','fontsize',14);
legend('svds','lmsvd','location','Best');
set(gca,'fontsize',12); grid on
axis square
shg