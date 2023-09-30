import os

file_path = os.getcwd() + "\MainMemory\initialise.coe"
with open(file_path, "w") as file:
    file.write("memory_initialization_radix=2;\n")
    file.write("memory_initialization_vector=\n")
    for i in range(0,65535):
        file.write("0000000000000000000000000000000000000000000000000000000000000000,\n")
    file.write("0000000000000000000000000000000000000000000000000000000000000000;\n")