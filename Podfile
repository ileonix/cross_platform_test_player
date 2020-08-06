# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/brightcove/BrightcoveSpecs.git'

target 'ios_player' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # Pods for ios_player
  platform :ios, '11.0'
  #pod 'BBTVPlayeriOS', :path => '/Users/chanonp/Desktop/iOS/BBTVPlayer-iOS'
  #pod 'BBTVPlayeriOS', :git => 'git@gitlab.com:bbtvnmd-mobile/BBTVPlayer-iOS.git', :branch => 'master'
  pod 'BBTVPlayeriOS', :git => 'git@gitlab.com:bbtvnmd-mobile/BBTVPlayer-iOS.git', :branch => 'feature/tvos'
  pod 'Brightcove-Player-Core/dynamic'
  pod 'Just'
  
  target 'ios_playerTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ios_playerUITests' do
    # Pods for testing
  end

end

target 'tvos_player' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # Pods for tvos_player
  platform :tvos, '11.0'
  #pod 'BBTVPlayeriOS', :path => '/Users/chanonp/Desktop/iOS/BBTVPlayer-iOS'
  pod 'BBTVPlayeriOS', :git => 'git@gitlab.com:bbtvnmd-mobile/BBTVPlayer-iOS.git', :branch => 'feature/tvos'
  pod 'Brightcove-Player-Core/dynamic'
  pod 'Just'
  
  target 'tvos_playerTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'tvos_playerUITests' do
    # Pods for testing
  end

end
