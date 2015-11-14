//
//  Question.swift
//  Find Your Strength
//
//  Created by 郭坤 on 15/11/11.
//  Copyright © 2015年 Lambda Theory. All rights reserved.
//

import Foundation
import CoreData

class Question : NSManagedObject {
    enum EntitiName : String {
        case Name = "Question"
    }
    
    enum Answer : Int {
        case Nil = -1
        case Yes = 0
        case Likely = 1
        case Neutral = 2
        case Unlikely = 3
        case No = 4
        
        static let score = [5, 4, 3, 2, 1]
        static let inversedScore = [1, 2, 3, 4, 5]
    }
    
    @NSManaged var answerRaw : Int16
    @NSManaged var id : Int32
    @NSManaged var survey : Survey
    
    var answer : Answer {
        get { return Answer(rawValue: Int(answerRaw)) ?? .Nil }
        set { answerRaw = Int16(newValue.rawValue) }
    }
    
    lazy var question : SurveyItem = {
        return SurveyLib.content(atIndex: Int(self.id))
    }()
    
    var content : String? {
        return question.content
    }
    var inversed : Bool {
        return question.inverse
    }
    var strength: Survey.Strength {
        return question.strength
    }
    
    func scoreForStrength(forAnswer:Answer) -> Int {
        return inversed ? Answer.inversedScore[answer.rawValue] : Answer.score[answer.rawValue]
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(survey: Survey, id : Int, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName(EntitiName.Name.rawValue, inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.id = Int32(id)
        self.survey = survey
        answer = .Nil
    }
}
/* javascript that obtain questions from www.authentichappiness.sas.upenn.edu
var result = document.getElementsByClassName("answer-radio-container");
var questions = ""
for (var i = 0; i < result.length; i++) {
    var container = result.item(i);
    var label = container.getElementsByTagName("label")[0];
    label.removeChild(label.childNodes[0]);
    questions += label.innerText + "\n"
}
alert(questions)
*/
/* questions en
I find the world a very interesting place.
I always go out of my way to attend educational events.
I always identify the reasons for my actions.
Being able to come up with new and different ideas is one of my strong points.
I am very aware of my surroundings.
I always have a broad outlook on what is going on.
I have taken frequent stands in the face of strong opposition.
I never quit a task before it is done.
I always keep my promises.
I am never too busy to help a friend.
I am always willing to take risks to establish a relationship.
I never miss group meetings or team practices.
I always admit when I am wrong.
In a group, I try to make sure everyone feels included.
I have no trouble eating healthy foods.
I have never deliberately hurt anyone.
It is important to me that I live in a world of beauty.
I always express my thanks to people who care about me.
I always look on the bright side.
I am a spiritual person.
I am always humble about the good things that have happened to me.
Whenever my friends are in a gloomy mood, I try to tease them out of it.
I want to fully participate in life, not just view it from the sidelines.
I always let bygones be bygones.
I am never bored.
I love to learn new things.
I always examine both sides of an issue.
When someone tells me how to do something, I automatically think of alternative ways to get the same thing done.
I know how to handle myself in different social situations.
Regardless of what is happening, I keep in mind what is most important.
I have overcome an emotional problem by facing it head on.
I always finish what I start.
My friends tell me that I know how to keep things real.
I really enjoy doing small favors for friends.
There are people in my life who care as much about my feelings and well-being as they do about their own.
I really enjoy being a part of a group.
Being able to compromise is an important part of who I am.
As a leader, I treat everyone equally well regardless of his or her experience.
Even when candy or cookies are under my nose, I never overeat.
Better safe than sorry is one of my favorite mottoes.
The goodness of other people almost brings tears to my eyes.
I get chills when I hear about acts of great generosity.
I can always find the positive in what seems negative to others.
I practice my religion.
I do not like to stand out in a crowd.
Most people would say I am fun to be with.
I never dread getting up in the morning.
I rarely hold a grudge.
I am always busy with something interesting.
I am thrilled when I learn something new.
I make decisions only when I have all of the facts.
I like to think of new ways to do things.
No matter what the situation, I am able to fit in.
My view of the world is an excellent one.
I never hesitate to publicly express an unpopular opinion.
I am a goal-oriented person.
I believe honesty is the basis for trust.
I go out of my way to cheer up people who appear down.
There are people who accept my shortcomings.
I am an extremely loyal person.
I treat all people equally regardless of who they might be.
One of my strengths is helping a group of people work well together even when they have their differences.
I am a highly disciplined person.
I always think before I speak.
I experience deep emotions when I see beautiful things.
At least once a day, I stop and count my blessings.
Despite challenges, I always remain hopeful about the future.
My faith never deserts me during hard times.
I do not act as if I am a special person.
I welcome the opportunity to brighten someone else's day with laughter.
I never approach things halfheartedly.
I never seek vengeance.
I am always curious about the world.
Every day, I look forward to the opportunity to learn and grow.
I value my ability to think critically.
I pride myself on being original.
I have the ability to make other people feel interesting.
I have never steered a friend wrong by giving bad advice.
I must stand up for what I believe even if there are negative results.
I finish things despite obstacles in the way.
I tell the truth even if it hurts.
I love to make other people happy.
I am the most important person in someone else's life.
I work at my very best when I am a group member.
Everyone's rights are equally important to me.
I am very good at planning group activities.
I control my emotions.
My friends believe that I make smart choices about what I say and do.
I see beauty that other people pass by without noticing.
If I receive a gift, I always let the person who gave it know I appreciated it.
I have a clear picture in my mind about what I want to happen in the future.
My life has a strong purpose.
I never brag about my accomplishments.
I try to have fun in all kinds of situations.
I love what I do.
I always allow others to leave their mistakes in the past and make a fresh start.
I am excited by many different activities.
I am a true life-long learner.
My friends value my objectivity.
I am always coming up with new ways to do things.
I always know what makes someone tick.
People describe me as "wise beyond my years."
I call for action while others talk.
I am a hard worker.
My promises can be trusted.
I have voluntarily helped a neighbor in the last month.
My family and close friends cannot do anything that would make me stop loving them.
I never bad-mouth my group to outsiders.
I give everyone a chance.
To be an effective leader, I treat everyone the same.
I never want things that are bad for me in the long run, even if they make me feel good in the short run.
I always avoid activities that are physically dangerous.
I have often been left speechless by the beauty depicted in a movie.
I am an extremely grateful person.
If I get a bad grade or evaluation, I focus on the next opportunity, and plan to do better.
In the last ~24 hours, I have spent 30 minutes in prayer, meditation or contemplation.
I am proud that I am an ordinary person.
I try to add some humor to whatever I do.
I look forward to each new day.
I believe it is best to forgive and forget.
I have many interests.
I always go out of my way to visit museums.
When the topic calls for it, I can be a highly rational thinker.
My friends say that I have lots of new and different ideas.
I always get along well with people I have just met.
I am always able to look at things and see the big picture.
I always stand up for my beliefs.
I do not give up.
I am true to my own values.
I always call my friends when they are sick.
I always feel the presence of love in my life.
It is important for me to maintain harmony within my group.
I am strongly committed to principles of justice and equality
I believe that our human nature brings us together to work for common goals.
I can always stay on a diet.
I think through the consequences every time before I act.
I am always aware of the natural beauty in the environment.
I go to extremes to acknowledge people who are good to me.
I have a plan for what I want to be doing five years from now.
My faith makes me who I am.
I prefer to let other people talk about themselves.
I never allow a gloomy situation to take away my sense of humor.
I have lots of energy.
I am always willing to give someone a chance to make amends.
I can find something of interest in any situation.
I read all of the time.
Thinking things through is part of who I am.
I am an original thinker.
I am good at sensing what other people are feeling.
I have a mature view on life.
I always face my fears.
I never get sidetracked when I work.
I take pride in not exaggerating who or what I am.
I am as excited about the good fortune of others as I am about my own.
I can express love to someone else.
Without exception, I support my teammates or fellow group members.
I refuse to take credit for work I have not done.
My friends always tell me I am a strong but fair leader.
I can always say "enough is enough."
I always keep straight right from wrong.
I greatly appreciate all forms of art.
I feel thankful for what I have received in life.
I know that I will succeed with the goals I set for myself.
I believe that each person has a purpose in life.
I rarely call attention to myself.
I have a great sense of humor.
I cannot wait to get started on a project.
I rarely try to get even.
It is very easy for me to entertain myself.
If I want to know something, I immediately go to the library or the Internet and look it up.
I always weigh the pro's and con's.
My imagination stretches beyond that of my friends.
I am aware of my own feelings and motives.
Others come to me for advice.
I have overcome pain and disappointment.
I stick with whatever I decide to do.
I would rather die than be phony.
I enjoy being kind to others.
I can accept love from others.
Even if I disagree with them, I always respect the leaders of my group.
Even if I do not like someone, I treat him or her fairly.
As a leader, I try to make all group members happy.
Without exception, I do my tasks at work or school or home by the time they are due.
I am a very careful person.
I am in awe of simple things in life that others might take for granted.
When I look at my life, I find many things to be grateful for.
I am confident that my way of doing things will work out for the best.
I believe in a universal power, a god.
I have been told that modesty is one of my most notable characteristics.
I find satisfaction in making others smile or laugh.
I can hardly wait to see what life has in store for me in the weeks and years ahead.
I am usually willing to give someone another chance.
I think my life is extremely interesting.
I read a huge variety of books.
I try to have good reasons for my important decisions.
In the last month I have found an original solution to a problem in my life.
I always know what to say to make people feel good.
I may not say it to others, but I consider myself to be a wise person.
I always speak up in protest when I hear someone say mean things.
When I make plans, I am certain to make them work.
My friends always tell me I am down to earth.
I am thrilled when I can let others share the spotlight.
I have a neighbor or someone at work or school that I really care about as a person.
It is important to me to respect decisions made by my group.
I believe that everyone should have a say.
As a leader, I believe that everyone in the group should have a say in what the group does.
For me, practice is as important as performance.
I always make careful choices.
I often have a craving to experience great art, such as music, drama, or paintings.
I feel a profound sense of appreciation every day.
If I feel down, I always think about what is good in my life.
My beliefs make my life important.
No one would ever describe me as arrogant.
I believe life is more of a playground than a battlefield.
I awaken with a sense of excitement about the day's possibilities.
I do not want to see anyone suffer, even my worst enemy.
I really enjoy hearing about other countries and cultures.
I love to read nonfiction books for fun.
My friends value my good judgment.
I have a powerful urge to do something original during this next year.
It is rare that someone can take advantage of me.
Others consider me to be a wise person.
I am a brave person.
When I get what I want, it is because I worked hard for it.
Others trust me to keep their secrets.
I always listen to people talk about their problems.
I easily share feelings with others
I gladly sacrifice my self-interest for the benefit of the group I am in.
I believe that it is worth listening to everyone's opinions.
When I am in a position of authority, I never blame others for problems.
I exercise on a regular basis.
I cannot imagine lying or cheating.
I have created something of beauty in the last year.
I have been richly blessed in my life.
I expect the best.
I have a calling in my life.
People are drawn to me because I am humble.
I am known for my good sense of humor.
People describe me as full of zest.
I try to respond with understanding when someone treats me badly.

Your Top Strength

Appreciation of beauty and excellence -

You notice and appreciate beauty, excellence, and/or skilled performance in all domains of life, from nature to art to mathematics to science to everyday experience.

Your Second Strength

Gratitude -

You are aware of the good things that happen to you, and you never take them for granted. Your friends and family members know that you are a grateful person because you always take the time to express your thanks.

Strength #3

Caution, prudence, and discretion -

You are a careful person, and your choices are consistently prudent ones. You do not say or do things that you might later regret.

Strength #4

Self-control and self-regulation -

You self-consciously regulate what you feel and what you do. You are a disciplined person. You are in control of your appetites and your emotions, not vice versa.

Strength #5

Leadership -

You excel at the tasks of leadership: encouraging a group to get things done and preserving harmony within the group by making everyone feel included. You do a good job organizing activities and seeing that they happen.


Strength #6

Hope, optimism, and future-mindedness -

You expect the best in the future, and you work to achieve it. You believe that the future is something that you can control.

Strength #7

Spirituality, sense of purpose, and faith -

You have strong and coherent beliefs about the higher purpose and meaning of the universe. You know where you fit in the larger scheme. Your beliefs shape your actions and are a source of comfort to you.

Strength #8

Forgiveness and mercy -

You forgive those who have done you wrong. You always give people a second chance. Your guiding principle is mercy and not revenge.

Strength #9

Zest, enthusiasm, and energy -

Regardless of what you do, you approach it with excitement and energy. You never do anything halfway or halfheartedly. For you, life is an adventure.

Strength #10

Humor and playfulness -

You like to laugh and tease. Bringing smiles to other people is important to you. You try to see the light side of all situations.

Strength #11

Modesty and humility -

You do not seek the spotlight, preferring to let your accomplishments speak for themselves. You do not regard yourself as special, and others recognize and value your modesty.

Strength #12

Fairness, equity, and justice -

Treating all people fairly is one of your abiding principles. You do not let your personal feelings bias your decisions about other people. You give everyone a chance.

Strength #13

Citizenship, teamwork, and loyalty -

You excel as a member of a group. You are a loyal and dedicated teammate, you always do your share, and you work hard for the success of your group.

Strength #14

Social intelligence -

You are aware of the motives and feelings of other people. You know what to do to fit in to different social situations, and you know what to do to put others at ease.

Strength #15

Creativity, ingenuity, and originality -

Thinking of new ways to do things is a crucial part of who you are. You are never content with doing something the conventional way if a better way is possible.

Strength #16

Judgment, critical thinking, and open-mindedness -

Thinking things through and examining them from all sides are important aspects of who you are. You do not jump to conclusions, and you rely only on solid evidence to make your decisions. You are able to change your mind.

Strength #17

Love of learning -

You love learning new things, whether in a class or on your own. You have always loved school, reading, and museums-anywhere and everywhere there is an opportunity to learn.

Strength #18

Perspective wisdom -

Although you may not think of yourself as wise, your friends hold this view of you. They value your perspective on matters and turn to you for advice. You have a way of looking at the world that makes sense to others and to yourself.

Strength #19

Bravery and valor -

You are a courageous person who does not shrink from threat, challenge, difficulty, or pain. You speak up for what is right even if there is opposition. You act on your convictions.

Strength #20

Capacity to love and be loved -

You value close relations with others, in particular those in which sharing and caring are reciprocated. The people to whom you feel most close are the same people who feel most close to you.

Strength #21

Kindness and generosity -

You are kind and generous to others, and you are never too busy to do a favor. You enjoy doing good deeds for others, even if you do not know them well.

Strength #22

Honesty, authenticity, and genuineness -

You are an honest person, not only by speaking the truth but by living your life in a genuine and authentic way. You are down to earth and without pretense; you are a "real" person.

Strength #23

Industry, diligence, and perseverance -

You work hard to finish what you start. No matter the project, you "get it out the door" in timely fashion. You do not get distracted when you work, and you take satisfaction in completing tasks.

Strength #24

Curiosity and interest in the world -

You are curious about everything. You are always asking questions, and you find all subjects and topics fascinating. You like exploration and discovery.
*/