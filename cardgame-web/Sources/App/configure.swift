import Vapor
import Fluent
import FluentSQLiteDriver
import Leaf

// Called before your application initializes.
func configure(_ app: Application) throws {
    // Serves files from `Public/` directory
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
        
    // Configure SQLite database
    app.databases.use(.sqlite(file: "db.sqlite"), as: .sqlite)

    // Configure migrations
    app.migrations.add(CreateTodo())
    
    // Configure Leaf
    app.views.use(.leaf)
    
    try routes(app)
}
