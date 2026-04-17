clear; close all; clc;

% wavファイル読み込み
[audioSig, fs] = audioread("sig1.wav");

% 各種パラメータ定義
windowLength = 4096; % 2の12乗(100msに最も近い2のべき乗の点数)
shiftLength = windowLength / 2;

function S = stft(audioSig, fs, windowLength, shiftLength)
    % 信号長確保
    signalLength = size(audioSig, 1);
    
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
    
    S = abs(S) .^ 2; % 要素ごとに絶対値の二乗
    S = 20 * log10(S); % 単位を[dB]に変換
    
    % パワースぺクトログラムを表示
    signalTime = signalLength / fs; % 信号の時間[s]
    timeAxis = linspace(0, signalTime, numFrame); % 時間軸(x軸)
    freqAxis = linspace(0, fs, windowLength); % 周波数軸(y軸)
    
    figure("Name", "パワースペクトログラムの描写");
    imagesc(timeAxis, freqAxis, S); % パワースぺクトログラムの描写
    colorbar; % カラーバーの表示
    title("スペクトログラム"); % タイトルの表示
    xlabel("時間 [s]"); % x軸ラベルの表示
    ylabel("周波数 [Hz]"); % y軸ラベルの表示
    ylim([0, fs/2]); % 周波数の上限を設定
    axis xy; % 周波数軸の上下を反転
    set(gca, "FontSize", 16); % フォントサイズの設定
end

s = stft(audioSig, fs, windowLength, shiftLength);