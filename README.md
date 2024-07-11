# PyREVengine

PyREVengine is a Dockerfile that provides you with a fully equipped container to reverse engineering [PyInstaller](https://pyinstaller.org/) executables. 


## Usage

The `docker_run.sh` bash script will take care of building the image from the Dockerfile, and it will start the container. 

You have to specify a local folder (where you placed your PyInstaller executables) that will be mounted in the container in the `/input` folder.

```
./docker_run.sh <FOLDER>
```


## Typical Workflow

1) [Pyinstxtractor](https://github.com/extremecoders-re/pyinstxtractor)

    - To extract the Python bytecode (`pyc`) from the executable
    - Read its output and take note of which version of Python was embedded in the executable, could help with the next step
    - Usage: `pyinstxtractor.py foo.exe`
    - It will create a folder named `foo.exe_extracted`


2) Decompilers (for the `pyc` files)

    - [1.0 <= `pyc` <= 3.8] [uncompyle6](https://github.com/rocky/python-uncompyle6/)
    - [`pyc` >= 3.7] [decompile3](https://github.com/rocky/python-decompile3)
    - [`pyc` == *] [Decompyle++](https://github.com/zrax/pycdc)


## Yara rule

There is also a battle-tested Yara rule (both textual `.yara` and compiled `.yarac`) to detect PyInstaller executables under `/root`.

Usage:

`yara -C /root/pyinstaller.yarac /input/`

If you need to scan multiple files, do not forget the parallel scan option:

`-p number --threads=number`

To use the specified number of threads to scan a directory.