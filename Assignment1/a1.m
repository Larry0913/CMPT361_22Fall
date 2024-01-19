%part1 Take two photograsphs
high_pass = im2double(rgb2gray(imread('HP1.png')));
low_pass = im2double(rgb2gray(imread("LP1.png")));
%imshow(high_pass);
%imshow(low_pass);

%part2 Compute frequency representations
highfreq = fft2(high_pass);
lowFreq = fft2(low_pass);
%imshow([fftshift(abs(highfreq))] / 50 );
%imshow([fftshift(abs(lowFreq))] / 50 );

%part3 Visualize kernels
gauskern = fspecial ('gaussian',15,2.5);
dog= fspecial('gaussian',15,2.5);
sob = [-1 0 1; -2 0 2; -1 0 1];
%surf(gauskern)
%surf(conv2(dog,sob))

hf_filt = imfilter(high_pass,gauskern);
lf_filt = imfilter(low_pass,gauskern);
%imshow (hf_filt);
%imshow (lf_filt);

high_filt_freq = fft2(hf_filt);
low_filt_freq = fft2(lf_filt);
%imshow([fftshift(abs(high_filt_freq))] / 10)
%imshow([fftshift(abs(low_filt_freq))] / 10)


dog_hp = (abs(imfilter(high_pass,conv2(dog,sob))));
dog_lp = (abs(imfilter(low_pass,conv2(dog,sob))));
%imshow (dog_hp);
%imshow (dog_lp);

dog_high_filt_freq = fft2(dog_hp);
dog_low_filt_freq = fft2(dog_lp);
%imshow([fftshift(abs(dog_high_fou_gaus))] / 10)
%imshow([fftshift(abs(dog_low_fou_gaus))] / 10)


%part4 Anti-aliasing
hp_half = (high_pass(1:2:end,1:2:end));
lp_half = (low_pass(1:2:end,1:2:end));
%imshow(hp_half)
%imshow(lp_half)

hp_half_freq = fft2(hp_half);
lp_half_freq = fft2(lp_half);
%imshow([fftshift(abs(hp_half_freq))] / 50)
%imshow([fftshift(abs(lp_half_freq))] / 50)

hp_sub4 = (high_pass(1:4:end,1:4:end));
lp_sub4 = (low_pass(1:4:end,1:4:end));
%imshow(hp_sub4)
%imshow(lp_sub4)

hp_sub4_freq = fft2(hp_sub4);
lp_sub4_freq = fft2(lp_sub4);
%imshow([fftshift(abs(hp_sub4_freq))] / 50)
%imshow([fftshift(abs(lp_sub4_freq))] / 50)

gauskern3 = fspecial('gaussian',2,0.1);
gauskern4 = fspecial('gaussian',5,0.5);

hp_half_aa = imfilter(hp_half,gauskern3);
%imshow (hp_half_aa);
hp_half_aa_freq = fft2(hp_half_aa);
%imshow([fftshift(abs(hp_half_aa_freq))] / 10)

hp_sub4_aa = imfilter(hp_sub4,gauskern4);
%imshow(hp_sub4_aa)
hp_sub4_aa_freq = fft2(hp_sub4_aa);
%imshow([fftshift(abs(hp_sub4_aa_freq))] / 50)

%Part5 Canny edge detection thresholding
[cannyedge, thresh1] = edge(high_pass,'canny');
%thresh1
%0.0438    0.1094
HP_canny_optimal = edge(high_pass,'canny',[0.0438, 0.1094]);
HP_canny_lowlow  =  edge(high_pass,'canny',[0.003,0.05]);
HP_canny_highlow = edge(high_pass,'canny',[0.08,0.09]);
HP_canny_lowhigh = edge(high_pass,'canny',[0.01,0.20]);
HP_canny_highhigh = edge(high_pass,'canny',[0.08,0.20]);

%imshow(HP_canny_optimal)
%imshow(HP_canny_lowlow)
%imshow(HP_canny_highlow)
%imshow(HP_canny_lowhigh)
%imshow(HP_canny_highhigh)

[cannyedge, thresh2] = edge(low_pass,'canny');
%thresh2
%0.0063    0.0156
LP_canny_lowlow = edge(low_pass,'canny',[0.001,0.005]);
LP_canny_highlow = edge(low_pass,'canny',[0.008,0.01]);
LP_canny_lowhigh = edge(low_pass,'canny',[0.001,0.05]);
LP_canny_highhigh = edge(low_pass,'canny',[0.05,0.08]);
LP_canny_optimal = edge(low_pass,'canny',[0.0063,0.0156]);
%imshow(LP_canny_optimal)
%imshow(LP_canny_lowlow)
%imshow(LP_canny_highlow)
%imshow(LP_canny_lowhigh)
%imshow(LP_canny_highhigh)

