import asyncio
import random
from math import floor

# Global address variable
address = "I:/asm/lab2/lab2.exe"

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
    if (int(control_result) == int(test_result)):
        if write_info == True:
            print("Test passed \n(\n args: {}, \n control_result: {} \n test_result: {}\n) \n \n".format(args, control_result, test_result))
        else:
            print("Test passed \n \n")    
    else:
        if write_info == True:
            print("Test failed \n(\n args: {}, \n control_result: {} \n test_result: {}\n) \n \n".format(args, control_result, test_result))   
        else:
            print("Test failed \n \n")         

def auto_test_run (address, lower_border, upper_border):
    a, b, y = random.randint(lower_border, upper_border), random.randint(lower_border, upper_border), random.randint(lower_border, upper_border)

    control_result = floor(floor(((floor((b-a))*floor(a*y))/4)) + floor((a*a)) - 2)


    test_result = asyncio.get_event_loop().run_until_complete(run(address, [a, b, y]))
    if (int(control_result) == int(test_result)):
        if write_info == True:
            print("Test passed \n(\n args: {}, \n control_result: {} \n test_result: {} \n) \n \n".format([a, b, y], control_result, test_result))
        else:
            print("Test passed \n \n")    
    else:
        if write_info == False:
            print("Test failed \n(\n args: {}, \n control_result: {} \n test_result: {}\n) \n \n".format([a, b, y], control_result, test_result))   
        else:
            print("Test failed \n \n")          


manual_test_run(address, [1,1,2], -1)
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