w = 160;
h = 280;

wall1 = line([0, 10], [20.05, 20.05]);
wall2 = line([13, 16], [20.05, 20.05]);

wx = 12.05;
wy = 7.05;

c = 3 * 10^8;
f = 3.6;
Pt = 10 * log10(5);
lamba = c / f;

signal = zeros(w, h);

for k = 1:w
  for p = 1:h
    isConnected1 = dwawektory(k/10, p/10, wx, wy, 0, 20.05, 10, 20.05);
    isConnected2 = dwawektory(k/10, p/10, wx, wy, 13, 20.05, 16, 20.05);

    if isConnected1 == -1 && isConnected2 == -1
      r = sqrt((wx - k/10)^2 + (wy - h/10)^2);

      FSL = 32.44 + 20 * log10(r) + 20 * log10(f);

      signal(k, p) = Pt - FSL;
    else
      signal(k, p) = -100;
    end
  end
end

[Y, X] = meshgrid(0.1:0.1:28, 0.1:0.1:16);