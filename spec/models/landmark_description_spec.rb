require 'spec_helper'

describe LandmarkDescription do
  subject { described_class.make! }
  it_behaves_like "an article"
  it { should belong_to :landmark }

  describe ".within_radius" do #TODO move to shared example group with landmarks and nodes altogether
    let(:triangle){ to_points [[10,10], [20,20], [30,10]] }
    let(:landmarks){ to_landmarks triangle }
    let(:descriptions){ landmarks_to_descriptions landmarks }

    it 'returns nodes within a specified radius of another node' do
      described_class.within_radius(triangle[0], 10).should =~ descriptions[0..0]
      described_class.within_radius(triangle[0], 15).should =~ descriptions[0..1]
      described_class.within_radius(triangle[0], 20).should =~ descriptions
      described_class.within_radius(triangle[2], 15).should =~ descriptions[1..2]
    end
  end

  describe '.search' do
    context 'for plain text queries' do
      let!(:d1){ described_class.make! title: 'Recreational fishing',
                                       body: """
                                          Recreational fishing, also called sport fishing,
                                          is fishing for pleasure or competition. It can be contrasted
                                          with commercial fishing, which is fishing for profit,
                                          or subsistence fishing, which is fishing for survival. """ }
      let!(:d2){ described_class.make! title: 'On the Nature of Animals',
                                       body: """
                                          a Macedonian way of catching fish... They fasten red (crimson red)
                                          wool round a hook, and fix on to the wool two feathers which grow
                                          under a cock's wattles, and which in colour are like wax. Their rod
                                          is six feet long, and their line is the same length. Then they
                                          throw their snare, and the fish, attracted and maddened
                                          by the colour, comes straight at it...""" }
      let!(:d3){ described_class.make! title: 'Sport fishing',
                                       body: """
                                          Sport fishing methods vary according to the area fished,
                                          the species targeted, the personal strategies of the angler,
                                          and the resources available. It ranges from the aristocratic art
                                          of fly fishing elaborated in Great Britain,[12] to the high-tech
                                          methods used to chase marlin and tuna. Sport fishing is usually done
                                          with hook, line, rod and reel rather than with nets or other aids. """ }
      let!(:d4){ described_class.make! title: 'Fishing tackle',
                                       body: """
                                          Fishing tackle is a general term that refers to the equipment used
                                          by fishers. Almost any equipment or gear used for fishing can be called
                                          fishing tackle. Some examples are hooks, lines, sinkers, floats, rods,
                                          reels, baits, lures, spears, nets, traps, waders and tackle boxes. """ }
      let!(:d5){ described_class.make! title: 'Fish logs',
                                       body: """
                                          In addition to capturing fish for food, recreational anglers might also
                                          keep a log of fish caught and submit trophy-sized fish to independent
                                          record keeping bodies. In the Republic of Ireland, the Irish Specimen Fish
                                          Committee verifies and publicizes the capture of trophy fish caught with
                                          rod and line by anglers in Ireland, both in freshwater and at sea. """ }

      it 'performs full text search against title and description' do
        described_class.search('Fishing').should =~ [d1, d3, d4]
        described_class.search('line').should =~ [d2, d3, d5] #TODO add fuzzy / dictionary based search
        described_class.search('fish').should =~ [d2, d5]
      end
    end
  end
end
