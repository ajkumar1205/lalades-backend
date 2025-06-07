use actix_web::*;

#[actix_web::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    println!("Running The server");
    println!("On address 0.0.0.0:8080");

    HttpServer::new(|| App::new().service(hello_world))
        .bind(("0.0.0.0", 8080))?
        .run()
        .await?;

    Ok(())
}

#[actix_web::get("/")]
async fn hello_world() -> Result<HttpResponse, Box<dyn std::error::Error>> {
    Ok(HttpResponse::Ok().body("Hey there, I am running"))
}
