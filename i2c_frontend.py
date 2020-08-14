import sys, getopt
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
        elif opt in ("-s", "--shoulder"):
            shoulderpos = arg
            print("Shoulder position: ", shoulderpos)
        elif opt in ("-e", "--elbow"):
            elbowpos = arg
            print("Elbow position: ", elbowpos)
        elif opt in ("-i", "--innerw"):
            inner_wristpos = arg
            print("Inner wrist position: ", inner_wristpos)
        elif opt in ("-m", "--middlew"):
            middle_wristpos = arg
            print("Middle wrist position: ", middle_wristpos)
        elif opt in ("-o", "--outerw"):
            outer_wristpos = arg
            print("Outer wrist position: ", outer_wristpos)
except getopt.GetoptError:
    print('Unrecognized command or invalid command. Type -h or --help for command info.')
    sys.exit(2)