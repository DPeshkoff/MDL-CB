import asyncio
import random
from copy import deepcopy
import os

# Global address variable
address = os.path.dirname(__file__) + "\lab4.exe"

write_info = False

# Single lab run
async def run(address, args):

    # Create subprocess with stdin, stdout, stderr
    proc = await asyncio.create_subprocess_exec(
        address,
        stdin=asyncio.subprocess.PIPE,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE)

    # Read first line ("Input matrix:") and output it to the console
    current_line = await proc.stdout.readline()
    if write_info == True: print(current_line.decode('utf-8').rstrip())


    # Input matrix and output it to the console
    for i in range(0,4):
        for j in range(0,6):

            proc.stdin.write(('{}\n\r'.format(args[i][j])).encode('utf-8')) 

            await proc.stdin.drain()

            await asyncio.sleep(0.02)

            if write_info == True: print(('{}'.format(args[i][j])), end=" ")
        
        if write_info == True: print("")


    proc.stdin.close()
    await proc.stdin.wait_closed()

    stdout, stderr = await proc.communicate()

    if write_info == True: print(f'[{address!r} exited with {proc.returncode}]')

    if write_info == True:
        if stdout:
            print(f'[stdout]\n{stdout.decode()}')
        if stderr:
            print(f'[stderr]\n{stderr.decode()}')

    # Prepare the resulting matrix
    resulting_array = list(map(int, stdout.decode().split("Press Enter")[0].split("Matrix:")[2].split()))
    result = [[resulting_array[i] for i in range(0+j*6, 6+j*6)] for j in range(0, 4)]

    return result



def manual_test_run (address, args, control_result):

    test_result = asyncio.get_event_loop().run_until_complete(run(address, args))
    if (control_result == test_result):

        if write_info == True:
            print("[M] Test passed \n(\n args: {}, \n control_result: {} \n test_result: {}\n) \n \n".format(args, control_result, test_result))
        else:
            print("[M] Test passed \n \n")    
    else:
        print("[M] Test failed \n(\n args: {}, \n control_result: {} \n test_result: {}\n) \n \n".format(args, control_result, test_result))      


def auto_test_run (address, lower_border, upper_border):

    args = [[random.randint(lower_border, upper_border) for i in range(0, 6)] for j in range(0, 4)]

    negative_sums = [0, 0, 0, 0]

    for i in range(0,4):
        for j in range(0,6):
            if args[i][j] < 0:
                negative_sums[i] += args[i][j]
                
    
    control_result = deepcopy(args)

    for i in range(0,4):
        control_result[i][0] = negative_sums[i]

    test_result = asyncio.get_event_loop().run_until_complete(run(address, args))

    try:
        test_result != []
    except:
        print("[A] ValueError: ", test_result)
        print("[A] Test broken \n(\n args: {}, \n control_result: {} \n test_result: {} \n) \n \n".format(args, control_result, test_result))
    else:
        if (control_result == test_result):
            if write_info == True:
                print("[A] Test passed \n(\n args: {}, \n control_result: {} \n test_result: {} \n) \n \n".format(args, control_result, test_result))
            else:
                print("[A] Test passed \n \n")    
        else:
            print("[A] Test failed \n(\n args: {}, \n control_result: {} \n test_result: {}\n) \n \n".format(args, control_result, test_result))    
             
# Main part of the program - no imports
if __name__ == '__main__':

    print("Lab4 tests")

    manual_test_run(address, [[1, -4, 0, 4, 5, 2], [-2, 4, -5, -2, 2, -1], [-5, 2, -3, 0, 2, -5], [5, 0, 0, 2, 3, 2]], [[-4, -4, 0, 4, 5, 2], [-10, 4, -5, -2, 2, -1], [-13, 2, -3, 0, 2, -5], [0, 0, 0, 2, 3, 2]])
    manual_test_run(address, [[5, 5, 1, 1, -5, -4], [-5, -4, 1, 4, 3, -5], [5, -4, -5, -1, -1, 3], [0, 5, -2, 4, 1, 0]], [[-9, 5, 1, 1, -5, -4], [-14, -4, 1, 4, 3, -5], [-11, -4, -5, -1, -1, 3], [-2, 5, -2, 4, 1, 0]])
    manual_test_run(address, [[0, -4, 1, 0, 1, -1], [1, 0, 4, -5, -2, -2], [-4, -3, 5, 2, 2, -3], [5, -2, -5, -2, 0, -3]], [[-5, -4, 1, 0, 1, -1], [-9, 0, 4, -5, -2, -2], [-10, -3, 5, 2, 2, -3], [-12, -2, -5, -2, 0, -3]])


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