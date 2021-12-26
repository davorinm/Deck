import Foundation
import DMToolbox

class AppDelegateRegistration {

    static func registerProviders() {
        let container = ServiceContainer()
        ServiceLocator.setContainerFactory(factory: container)
        
        // LobbyService
        container.set(manager: ContainerLifetimeManager()) { LobbyServiceImpl() as LobbyService }

        // GameService
        container.set(manager: ContainerLifetimeManager()) { GameServiceImpl() as GameService }
    }
}
