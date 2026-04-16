clear; close all; clc;

% wavファイル読み込み
[audioSig, fs] = audioread("sig1.wav");
% 信号長確保
signalLength = size(audioSig, 1);

% 各種パラメータ定義
windowLength = 4096; % 2の12乗
shiftLength = windowLength / 2;

% ゼロパディング
% paddedSig = padarray(padarray(audioSig, windowLength / 2, 0, "pre"), windowLength - 1, 0, "post");
paddedSig = [zeros(shiftLength, 1) ; audioSig ; zeros(windowLength - 1, 1)];

% 信号の分割
numFrame = ceil((shiftLength + signalLength) / shiftLength); % フレーム数
win = hann(windowLength); % ハン窓作成
S = zeros(windowLength, numFrame); % 複素スペクトログラムを入れる用の変数

for i = 1 : numFrame 
    startIndex = 1 + (i - 1) * shiftLength;
    endIndex = startIndex + windowLength - 1;

    S(:, i) = paddedSig(startIndex : endIndex); % 信号を分割して代入
    S(:, i) = S(:, i) .* win; % 窓かけ
    S(:, i) = fft(S(:, i)); %DFT
end