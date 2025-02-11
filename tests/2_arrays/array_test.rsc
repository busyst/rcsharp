fn main(){
    let x: [u8;32];
    x[0] = 0;
    x[1] = 1;
    let i:u8 = 2;
    loop{
        if i >= 32{
            break;
        }
        x[i] = x[i - 1] + x[i - 2];
        i+=1;
    }
    print_num(x[0]);
    print_num(x[1]);
    print_num(x[2]);
    print_num(x[3]);
    print_num(x[4]);
    print_num(x[5]);
    print_num(x[6]);
    print_num(x[7]);
    print_num(x[8]);
    print_num(x[9]);
}


fn print_num(n: u8){
    asm!("
        mov al, {n}
        shr al, 4
        add al, 48

        cmp al, 58
        jb I_L0
        add al, 7
        I_L0:
        mov ah, 0x0e
        int 0x10

        mov al, {n}
        and al, 0x0F
        add al, 48

        cmp al, 58
        jb I_L1
        add al, 7
        I_L1:
        mov ah, 0x0e
        int 0x10
    ");
}