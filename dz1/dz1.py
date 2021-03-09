import asyncio
import random
import os
import string

# Global address variable
address = os.path.dirname(__file__) + "\dz1.exe"

write_info = False

VOWELS = ["a","e","i","o","u"]

# Single lab run
async def run(address, args):

    # Create subprocess with stdin, stdout, stderr
    proc = await asyncio.create_subprocess_exec(
        address,
        stdin=asyncio.subprocess.PIPE,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE)

    # Read first line ("Input string:") and output it to the console
    current_line = await proc.stdout.readline()
    if write_info == True: print(current_line.decode('utf-8').rstrip())

    proc.stdin.write(('{}\n\r'.format(args)).encode('utf-8')) 
    await proc.stdin.drain()
    await asyncio.sleep(0.02)

    if write_info == True: print(('{}'.format(args)), end=" ")


    proc.stdin.close()
    await proc.stdin.wait_closed()

    stdout, stderr = await proc.communicate()

    await asyncio.sleep(0.02)

    if write_info == True: print(f'\n[{address!r} exited with {proc.returncode}]')

    if write_info == True:
        if stdout:
            print(f'[stdout]\n{stdout.decode()}')
        if stderr:
            print(f'[stderr]\n{stderr.decode()}')

    # Prepare the resulting matrix
    result = list(map(int, stdout.decode().split("Press Enter")[0].split()))

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

    args = ''
    for i in range (0, 2):
        args += 'a'
        args = args.join(random.SystemRandom().choice(string.ascii_lowercase) for _ in range(lower_border,upper_border))
        args += 'e'
        args += ' '

    control_result = []

    largs = args.split()
    for i in range(0, len(largs)):
        if (largs[i][0] in VOWELS and largs[i][len(largs[i])-1]):
            control_result.append(i+1)


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

    print("Dz1 tests")

    manual_test_run(address, "fgadavafaqe afgadavafaqe argadavafaqe aegadavafaqe aye ", [2, 3, 4, 5])
    manual_test_run(address, "ado from nothing edidio ", [1, 4])
    manual_test_run(address, "adaaahawaje afdaaahawaje afdaaahawaje abdaaahawaje aze ", [1, 2, 3, 4, 5])


    auto_test_run(address, 0, 5)
    auto_test_run(address, 0, 5)
    auto_test_run(address, 0, 5)
    auto_test_run(address, 0, 5)
    auto_test_run(address, 0, 5)
    auto_test_run(address, 0, 5)
    auto_test_run(address, 0, 5)
    auto_test_run(address, 0, 5)
    auto_test_run(address, 0, 5)
    auto_test_run(address, 0, 5)

