ioreg -l -w 0 \
    | perl -nle 'print $1 if /"kCGSSessionSecureInputPID"=(\d+)/' \
    | uniq \
    | xargs -I{} ps -p {} -o comm=
