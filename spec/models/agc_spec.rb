require 'spec_helper'

describe Area do
  let(:id_to_name) { Hash[(1..3).map { |n| [n, "name#{n}"] }] }
  let(:delete_query) { id_to_name.keys.map { |n| "delete from relations where id = #{n};" }.join }
  before :all do
    ActiveRecord::Base.connection.execute(
        delete_query +
            id_to_name.map do |id, name|
              "insert into relations (id, version, user_id, tstamp, changeset_id) values (#{id}, 1, 1, TIMESTAMP '2011-11-11 11:11:11', 1); UPDATE relations SET tags = ('name' => '#{name}') where id = #{id};"
            end.join)
  end
  after :all do
    ActiveRecord::Base.connection.execute(delete_query)
  end

  let(:agc) { Agc.create relations: [1, 2, 3] }

  describe '#names' do
    it 'returns a chain of relation ids with names' do
      agc.names.should == id_to_name
    end
  end
end
