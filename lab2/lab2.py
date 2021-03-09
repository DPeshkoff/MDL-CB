import asyncio
import random
from math import trunc
import os

# Global address variable
address = os.path.dirname(__file__) + "\lab2.exe"

write_info = False

# Single lab run
async def run(address, args):

    # Create subprocess with stdin, stdout, stderr
    proc = await asyncio.create_subprocess_exec(
        address,
        stdin=asyncio.subprocess.PIPE,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE)

    # Read first line ("Input A:") and output it to the console
    current_line = await proc.stdout.readline()
    if write_info == True: print(current_line.decode('ascii').rstrip())

    # Input first argument and output it to the console
    proc.stdin.write('{}\n\r'.format(args[0]).encode("utf-8"))
    if write_info == True: print(args[0])

    await proc.stdin.drain()

    # Read second line ("Input B:") and output it to the console
    current_line = await proc.stdout.readline()
    if write_info == True: print(current_line.decode('ascii').rstrip())

    # Input second argument and output it to the console
    proc.stdin.write('{}\n\r'.format(args[1]).encode("utf-8"))
    if write_info == True: print(args[1])

    await proc.stdin.drain()

    # Read third line ("Input Y:") and output it to the console
    current_line = await proc.stdout.readline()
    if write_info == True: print(current_line.decode('ascii').rstrip())
    
    # Input last argument and output it to the console
    proc.stdin.write('{}\n\r'.format(args[2]).encode("utf-8"))
    if write_info == True: print(args[2])

    await proc.stdin.drain()

    # Read fourth line ("Result:") and output it to the console
    current_line = await proc.stdout.readline()
    if write_info == True: print(current_line.decode('ascii').rstrip())

    # Read the result and output it to the console
    result = await proc.stdout.readline()
    if write_info == True: print(result.decode('ascii').rstrip())

    # Terminate the process
    proc.terminate()

    return result.decode('ascii').strip()



def manual_test_run (address, args, control_result):
    test_result = asyncio.get_event_loop().run_until_complete(run(address, args))
    try:
        int(test_result)
    except:
        print("ValueError: ", test_result)
        print("Test broken \n(\n args: {}, \n control_result: {} \n test_result: {} \n) \n \n".format(args, control_result, test_result))
    else:
        if (int(control_result) == int(test_result)):
            if write_info == True:
                print("[M] Test passed \n(\n args: {}, \n control_result: {} \n test_result: {}\n) \n \n".format(args, control_result, test_result))
            else:
                print("[M] Test passed \n \n")    
        else:
            print("[M] Test failed \n(\n args: {}, \n control_result: {} \n test_result: {}\n) \n \n".format(args, control_result, test_result))          

def auto_test_run (address, lower_border, upper_border):
    a, b, y = random.randint(lower_border, upper_border), random.randint(lower_border, upper_border), random.randint(lower_border, upper_border)

    control_result = trunc((a * y * (b - a))/4) + a * a - 2


    test_result = asyncio.get_event_loop().run_until_complete(run(address, [a, b, y]))
    try:
        int(test_result)
    except:
        print("[A] ValueError: ", test_result)
        print("[A] Test broken \n(\n args: {}, \n control_result: {} \n test_result: {} \n) \n \n".format([a, b, y], control_result, test_result))
    else:
        if (int(control_result) == int(test_result)):
            if write_info == True:
                print("[A] Test passed \n(\n args: {}, \n control_result: {} \n test_result: {} \n) \n \n".format([a, b, y], control_result, test_result))
            else:
                print("[A] Test passed \n \n")    
        else:
            print("[A] Test failed \n(\n args: {}, \n control_result: {} \n test_result: {}\n) \n \n".format([a, b, y], control_result, test_result))   
                      
# Main part of the program - no imports
if __name__ == '__main__':
    print("Lab2 tests")
    manual_test_run(address, [1,1,2], -1)
    manual_test_run(address, [3,4,3], 9)
    manual_test_run(address, [0,3,-3], -2)
    auto_test_run(address, -5, 5)
    auto_test_run(address, -5, 5)
    auto_test_run(address, -5, 5)
    auto_test_run(address, -5, 5)
    auto_test_run(address, -5, 5)
    auto_test_run(address, -5, 5)
    auto_test_run(address, -5, 5)
    auto_test_run(address, -5, 5)
    auto_test_run(address, -5, 5)
    auto_test_run(address, -5, 5)