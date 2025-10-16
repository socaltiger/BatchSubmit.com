k = 1
s = 0

for i in range(100000000):
    if i % 2 == 0:
        s += 4/k
    else:
        s -= 4/k
    k += 2

print(s)