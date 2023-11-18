cloase all; clear all;

width = 48;
height = 38

rectangle('Position', [0 0 width height], 'EdgeColor', 'b', 'LineWidth', 1);

hold on;

uwb = [
  10.5, 26.5, 40.5;
  2.5, 2.5, 2.5
];

odb = [
  7, 30, 44.5;
  36.5, 36.5, 36.5
];

pX = randi([0, width], 1);
pY = randi([0, height], 1);

realLines = zeros(3, 3)

axis equal;

rectangle('Position', [pX pY 1 1], 'FaceColor', 'b');

for a = 1:length(uwb(1, :))
  for b = 1:length(odb(1, :))
    plot(uwb(1, a), uwb(2, a), 'O');
    plot(odb(1, b), odb(2, b), 'O');

    hold on;

    isCrossed = wektorsektor(uwb(1, a), uwb(2, a), odb(1, b),odb(2, b), pX, pY, 1, 1);

    if isCrossed == 1 || isCrossed == -1
      line([uwb(1, a) odb(1, b)], [uwb(2, b) odb(2, a)], 'Color', 'r');

      realLines(a, b) = 1;
    else
      line([uwb(1, a) odb(1, b)], [uwb(2, b) odb(2, a)], 'Color', 'g');
    end
  end
end

for a = 1:width
  for b = 1:height

    lines = zeros(3, 3);

    for c = 1:length(uwb(1, :))
      for d = 1:length(odb(1, :))

        isCrossed = wektorsektor(uwb(1, c), uwb(2, c), odb(1, d),odb(2, d), pX, pY, 1, 1);

        if isCrossed ~= -1
          lines(c, d) = 1;
        end
      end
    end

    if isEqual(realLines, lines)
      rectangle('Position', [a b 1 1], 'FaceColor', 'b');
    end
  end
end


