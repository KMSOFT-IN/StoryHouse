//
//  StoryList.swift
//  StoryHouse
//
//  Created by iMac on 11/01/23.
//

import Foundation



class Story {
    
    var storyDetail : [String]?
    var storyImage: [String]?
    
    init(storyDetail: [String]?, storyImage: [String]?) {
        self.storyDetail = storyDetail
        self.storyImage = storyImage
    }
    
    static var storyList = [
        "Once upon a time, in a far-off galaxy, there was a young zebra named Zara. She had always been fascinated by the stars and dreamed of one day exploring outer space." ,
        
        "One day, as she was wandering through the savannah, she stumbled upon a mysterious wand lying in the grass. The wand was made of a shimmering silver material and had strange symbols etched into its surface. Zara couldn't resist picking it up and as soon as she touched it, she knew it was special.",
        
        "With the wand in her possession, Zara set off on an adventure to explore the galaxy. She climbed aboard a spaceship and blasted off into the stars. As she traveled through space, she encountered all sorts of strange and wonderful things. She met alien creatures, saw planets made of ice, and flew through nebulas that looked like they were on fire." ,
        
        "One day, while exploring a distant planet, Zara came across a group of robots that had gone haywire and were attacking the local alien inhabitants. Zara knew she had to do something to stop them. She pointed her wand at the robots and shouted Stop! To her surprise, the robots immediately froze in place." ,
        
        "Zara soon discovered that her wand had the power to control machines and she used it to stop the robots from causing any more harm. The alien inhabitants were grateful to Zara for saving them and invited her to stay with them for a while." ,
        
        "While she was on the planet, Zara met a wise alien who taught her how to use her wand to its full potential. She learned how to fly through space, create shields, and create beams of energy. With her new abilities, Zara continued her journey, helping any alien she met along the way." ,
        
        "One day, Zara received an urgent message from her home planet. Her herd was in danger and they needed her help." ,
        
        "Without hesitation, Zara flew back to her home planet, using her wand to protect her herd from a group of hostile alien invaders." ,
        
        "Thanks to Zara's bravery and the power of her wand, the alien invaders were defeated, and her herd was safe. From that day on, Zara became known as the protector of her planet, and she continued to use her wand to help others in the galaxy." ,
        
        "As the years passed, Zara's wand became a symbol of hope and protection throughout the galaxy. Even when she was an old zebra, she was still able to use her wand to help others, and her legend lived on for many generations to come."
    ]
    
    static var storyListImage = [ "s11","s12","ic_startStory1","ic_startStory2","ic_startStory1","ic_startStory2","ic_startStory1","ic_startStory2","ic_startStory1","ic_startStory2"
    ]
    
    
    static var story: Story = 
        Story(storyDetail: Story.storyList, storyImage: Story.storyListImage)
}






