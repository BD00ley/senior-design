import sys, getopt
from subprocess import call

base_addr = 16
shoulder_addr = 15
elbow_addr = 14
innerw_addr = 13
middlew_addr = 12
outerw_addr = 11

try:
    opts, args = getopt.getopt(sys.argv[1:], "hb:s:e:i:m:o:", ["help", "base=","shoulder=", "elbow=", "innerw=", "middlew", "outerw"])
    for opt, arg in opts: 
        if opt in  ("-h", "--help"):
            print ("-b, --base\t Set the base position")
            print ("-s, --shoulder\t Set the shoulder position")
            print ("-e, --elbow\t Set the elbow position")
            print ("-i, --innerw\t Set the inner wrist position")
            print ("-m, --middlew\t Set the middle wrist position")
            print ("-o, --outerw\t Set the outer wrist position")
            sys.exit()
        elif opt in ("-b", "--base"):
            basepos = arg
            print("Base position: ", basepos)
            call(["./i2c_backend", "--set-position", str(base_addr), str(basepos)])
        elif opt in ("-s", "--shoulder"):
            shoulderpos = arg
            print("Shoulder position: ", shoulderpos)
            call(["./i2c_backend", "--set-position", str(shoulder_addr), str(shoulderpos)])
        elif opt in ("-e", "--elbow"):
            elbowpos = arg
            print("Elbow position: ", elbowpos)
            call(["./i2c_backend", "--set-position", str(elbow_addr), str(elbowpos)])
        elif opt in ("-i", "--innerw"):
            inner_wristpos = arg
            print("Inner wrist position: ", inner_wristpos)
            call(["./i2c_backend", "--set-position", str(innerw_addr), str(inner_wristpos)])
        elif opt in ("-m", "--middlew"):
            middle_wristpos = arg
            print("Middle wrist position: ", middle_wristpos)
            call(["./i2c_backend", "--set-position", str(middlew_addr), str(middle_wristpos)])
        elif opt in ("-o", "--outerw"):
            outer_wristpos = arg
            print("Outer wrist position: ", outer_wristpos)
            call(["./i2c_backend", "--set-position", str(outerw_addr), str(outer_wristpos)])
except getopt.GetoptError:
    print('Unrecognized command or invalid command. Type -h or --help for command info.')
    sys.exit(2)