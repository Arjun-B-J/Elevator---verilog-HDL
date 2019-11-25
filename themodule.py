f = open('temperature_readings', 'w')


while True:
    # read form arduino
    f.write(value+'\n')