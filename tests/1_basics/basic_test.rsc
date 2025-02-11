fn main(){
    arythm();
    arythm1();
    arythm2(2);
    arythm3(3);
    let x: u8 = 127;
    let y: u16 = 32767;
    let z: u16 = arythm3(x);
    let w: u16 = arythm5(y);
    print_num(x);
    print_num(y);
    print_num(z);
    print_num(w);
}
fn arythm(){
    
}
fn arythm1() -> u16{
    return 137;
}
fn arythm2(a: u16){
    
}
fn arythm3(a: u16) -> u16{
    return a;
}
fn arythm4(a: u8){
    
}
fn arythm5(a: u8) -> u8{
    return a;
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