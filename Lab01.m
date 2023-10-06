range = 10000;
SNR = 8;

src = randi([0, 1], range, 1);

modulator = comm.PSKModulator(2, 0);
channel = comm.AWGNChannel("NoiseMethod", "Signal to noise ratio(SNR)", "SNR", SNR);
demodulator = comm.PSKDemodulator(2, 0);
errorRateChecker = comm.ErrorRate();

sign = modulator(src);

scatterplot(sign);

outputFromChanel = channel(sign);

scatterplot(outputFromChanel)

recived = demodulator(outputFromChanel);

scatterplot(recived);

errorRateChecker(src, recived);