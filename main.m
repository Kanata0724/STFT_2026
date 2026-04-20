clear; close all; clc;

% wavファイル読み込み
[audioSig, fs] = audioread("sig1.wav");

% 各種パラメータ定義
windowLength = 4096; % 2の12乗(100msに最も近い2のべき乗の点数)
shiftLength = windowLength / 2;

powerSpec = STFT(audioSig, fs, windowLength, shiftLength);