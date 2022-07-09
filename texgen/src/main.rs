use chrono::Datelike;

fn _header() -> String {
    let author = "Leothelion";
    let version_year = chrono::Utc::now().year();
    let version_month = chrono::Utc::now().month();

    let hdr_text = format!("{:%<40}\n%  AUTHOR: {}\n% VERSION: {}.{}\n{:%<40}\n",
        "%", author, version_year, version_month, "%");
    hdr_text
}

fn _footer() -> String {
    let catcode_revert = "\\makeatother";
    let colour_maths = "\\everymath\\expandafter{\\the\\everymath\\color{fg}}";
    let randomise_theme_at_begin = "\\AtBeginDocument{\\randomTheme\\pagecolor{bg}}";
    let fg_in_all_begins = "\\def\\begin#1{\\endgroup \\begin{#1}\\color{fg}}";
    let ftr_text = format!("{}\n{}\n{}\n{}\n",
        catcode_revert, colour_maths, randomise_theme_at_begin, fg_in_all_begins);
    ftr_text
}


fn main() {
    let hdr = _header();
    let ftr = _footer();

    println!("{}\n\n{}",
        hdr, ftr);
}
