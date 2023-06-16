package main

import (
	"flag"

	"github.com/ndbeals/winssh-pageant/pageant"
)

var (
	sshPipe       = flag.String("sshpipe", `\\.\pipe\openssh-ssh-agent`, "Named pipe for Windows OpenSSH agent")
	noPageantPipe = flag.Bool("no-pageant-pipe", false, "Toggle pageant named pipe proxying (this is different from the windows OpenSSH pipe)")
)

func main() {
	flag.Parse()

	p := pageant.NewDefaultHandler(*sshPipe, !*noPageantPipe)

	p.Run()
}
