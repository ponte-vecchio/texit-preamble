use chrono::Datelike;

fn _header() -> String {
    let author = "Leothelion";
    let version_year = chrono::Utc::now().year();
    let version_month = chrono::Utc::now().month();

    let hdr_text = format!("{:%<40}\n%  AUTHOR: {}\n% VERSION: {}.{}\n{:%<40}\n",
        "%", author, version_year, version_month, "%");
    hdr_text
}


fn main() {
    let hdr = _header();

    println!("{}", hdr);
}
