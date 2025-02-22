struct Lol{
    x:u16,
    y:u16,
}
struct ALol{
    x:Lol,
    y:Lol,
    z:u8,
}
fn main(){
    let y: ALol;
    let x: ALol;

    x.x.x = 1;
    x.x.y = 2;
    x.y.x = 3;
    x.y.y = 4;
    x.z = 5;

    y.x.x = 1;
    y.x.y = 2;
    y.y.x = 3;
    y.y.y = 4;
    y.z = 5;

    x.z += y.z;
}