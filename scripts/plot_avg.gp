set terminal png enhanced
set output "average_profile.png"

set title "Vertically Averaged Profile of u"
set xlabel "x (m)"
set ylabel "Averaged u"
set xrange [0:30]
set grid

# Plot as a line graph
plot "average.dat" with lines title "Vertical Average"
