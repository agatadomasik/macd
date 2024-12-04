Data = readtable("pkn_d.csv")

%Data_1.Date

% OKRES TESTOWY 1

Data_1 = Data(1:100,:);

% wykres notowań w pierwszych 100 dniach
plot(Data_1.Date, Data_1.Close, 'k');
title('Orlen SA - first 100 days')

% obliczenie MACD i SIGNAL
EMA12_1 = calcEMA(Data_1.Close, 12);
EMA26_1 = calcEMA(Data_1.Close, 26);
MACD_1 = EMA12_1 - EMA26_1;
SIGNAL_1 = calcEMA(MACD_1, 9);

% wykres MACD w pierwszych 100 dniach
figure;
plot(Data_1.Date, MACD_1, 'r');
hold on;
plot(Data_1.Date, SIGNAL_1, 'b');

title('Orlen SA - first 100 days - MACD-SIGNAL');
legend('MACD', 'SIGNAL');
grid on;
hold off;


% symulacja handlu
money_1 = 1000;
stocks_1 = 0;
%stocks_1 = money_1 / Data_1.Close(1);

capital_1 = zeros(height(Data_1.Close), 1);
capital_1(1) = money_1;
%money_1 = 0;

for i = 1:numel(Data_1.Close)
    if MACD_1(i) > SIGNAL_1(i) && MACD_1(i - 1) < SIGNAL_1(i - 1)
        stocks_1 = money_1 / Data_1.Close(i);
        money_1 = 0;
    elseif MACD_1(i) < SIGNAL_1(i) && MACD_1(i - 1) > SIGNAL_1(i - 1)
        if stocks_1 > 0
            money_1 = stocks_1 * Data_1.Close(i);
        end
        stocks_1 = 0;
    end
    capital_1(i) = money_1 + stocks_1 * Data_1.Close(i);
end


% wykres kapitału w pierwszych 100 dniach
figure;
plot(Data_1.Date, capital_1);
xlabel('Date');
ylabel('Capital');
title('Orlen SA - first 100 days - capital');
grid on;





% SYMULACJA NA WSZYSTKICH DANYCH

% wykres notowań
figure;
plot(Data.Date, Data.Close);
xlabel('Data');
ylabel('Close price');
title('Orlen SA - 1000 days');
grid on;


% obliczenie MACD i SIGNAL
EMA12 = calcEMA(Data.Close, 12);
EMA26 = calcEMA(Data.Close, 26);

MACD = EMA12 - EMA26
SIGNAL = calcEMA(MACD, 9)

% wykres MACD-SIGNAL
figure;
plot(Data.Date, MACD, 'r');
hold on;
plot(Data.Date, SIGNAL, 'b');
legend('MACD', 'SIGNAL');
title('Orlen SA - 1000 days - MACD-SIGNAL')
grid on;
hold off;

% symulacja handlu
money = 1000;
stocks = 0;
capital = zeros(height(Data), 1);
capital(1) = money;
%stocks = money / Data.Close(1);
%money = 0;
for i = 2:numel(Data.Close)
    if MACD(i) > SIGNAL(i) && MACD(i - 1) < SIGNAL(i - 1)
        stocks = money / Data.Close(i);
        money = 0;
    elseif MACD(i) < SIGNAL(i) && MACD(i - 1) > SIGNAL(i - 1)
        if stocks > 0
            money = stocks * Data.Close(i);
        end
        stocks = 0;
    end
    capital(i) = money + stocks * Data.Close(i);
end

% wykres kapitału w czasie
figure;
plot(Data.Date, capital);
xlabel('Date');
ylabel('Capital');
title('Orlen SA - 1000 days - capital');
grid on;

avg_capital = mean(capital);
min_capital = min(capital);
max_capital = max(capital);

fprintf('1000 dni:\n');
fprintf('Minimalna wartość kapitału: %.2f\n', min_capital);
fprintf('Maksymalna wartość kapitału: %.2f\n', max_capital);
fprintf('Średnia wartość kapitału: %.2f\n', avg_capital);
fprintf('Końcowa wartość kapitału: %.2f\n', capital(1000));


avg_capital_1 = mean(capital_1);
min_capital_1 = min(capital_1);
max_capital_1 = max(capital_1);

fprintf('Pierwsze 100 dni:\n');
fprintf('Minimalna wartość kapitału: %.2f\n', min_capital_1);
fprintf('Maksymalna wartość kapitału: %.2f\n', max_capital_1);
fprintf('Średnia wartość kapitału: %.2f\n', avg_capital_1);
fprintf('Końcowa wartość kapitału: %.2f\n', capital_1(100));


function ema = calcEMA(data, period)
    alpha = 2 / (period + 1);
    ema = zeros(size(data));
    ema(1) = data(1);
    for i = 2:numel(data)
        ema(i) = alpha * data(i) + (1 - alpha) * ema(i - 1);
    end
end