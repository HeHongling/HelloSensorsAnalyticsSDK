
platform :ios, '11.0'
workspace 'HelloSensorsAnalytics.xcworkspace'

abstract_target 'abstract_HelloSensorsAnalytics' do
    pod 'SensorsAnalyticsSDK'
    pod 'Masonry'
    pod 'HFFoundation', :git=>'https://github.com/HeHongling/HFFoundation.git'

    target :HelloSensorsAnalytics do
    project 'HelloSensorsAnalytics.xcodeproj'
    end

    
    target :MultiStatistics do
        project 'Examples/MultiStatistics/MultiStatistics.xcodeproj'
        pod 'UMCAnalytics'
    end
    
    
    target :BackgroundMode do
    project 'Examples/BackgroundMode/BackgroundMode.xcodeproj'
        pod 'JPush'
    end
    
end

