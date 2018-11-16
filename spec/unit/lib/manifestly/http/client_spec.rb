require 'spec_helper'
require 'manifestly'

describe Manifestly::Client do
  let(:instance) { described_class.new(url: url, api_version: api_version, api_key: api_key) }
  let(:url) { random }
  let(:api_version) { random }
  let(:api_key) { random }

  describe '.initialize' do
    subject { instance }

    it 'sets instance variables' do
      expect(subject.url).to eq url
      expect(subject.api_version).to eq api_version
      expect(subject.api_key).to eq api_key
    end

    context 'when no inputs given' do
      let(:url) { nil }
      let(:api_version) { nil }

      it 'sets defaults' do
        expect(subject.url).to eq Manifestly::Client::DEFAULT_URL
        expect(subject.api_version).to eq Manifestly::Client::DEFAULT_API_VERSION
      end
    end

    context 'when api key is missing' do
      let(:api_key) { nil }

      it 'raises error' do
        expect { subject }.to raise_error(/key is required/)
      end
    end
  end

  describe '.get' do
    subject { instance.get(path, params: params, headers: headers) }
    let(:path) { random }
    let(:params) { Object.new }
    let(:headers) { Object.new }

    it 'calls handle_request and raw_get' do
      expect(instance).to receive(:handle_request).and_yield
      expect(instance).to receive(:raw_get).with("#{url}/#{api_version}/#{path}", params: params, headers: headers)
      subject
    end
  end

  describe '.raw_get' do
    subject { instance.raw_get(path, params: params, headers: headers) }
    let(:path) { random }
    let(:params) { Object.new }
    let(:headers) { Object.new }

    it 'sends the GET request' do
      expect(instance).to receive(:include_api_key!)
      expect(instance).to receive(:include_json_accept!)
      expect(Faraday).to receive(:get).with(path, params, headers)
      subject
    end
  end

  describe '.post' do
    subject { instance.post(path, params: params, headers: headers) }
    let(:path) { random }
    let(:params) { Object.new }
    let(:headers) { Object.new }

    it 'calls handle_request and raw_post' do
      expect(instance).to receive(:handle_request).and_yield
      expect(instance).to receive(:raw_post).with("#{url}/#{api_version}/#{path}", params: params, headers: headers)
      subject
    end
  end

  describe '.raw_post' do
    subject { instance.raw_post(path, params: params, headers: headers) }
    let(:path) { random }
    let(:params) { Object.new }
    let(:headers) { Object.new }

    it 'sends the POST request' do
      expect(instance).to receive(:include_api_key!)
      expect(instance).to receive(:include_json_content_type!)
      expect(instance).to receive(:include_json_accept!)
      expect(Faraday).to receive(:post).with(path, params.to_json, headers)
      subject
    end
  end

  describe '.put' do
    subject { instance.put(path, params: params, headers: headers) }
    let(:path) { random }
    let(:params) { Object.new }
    let(:headers) { Object.new }

    it 'calls handle_request and raw_put' do
      expect(instance).to receive(:handle_request).and_yield
      expect(instance).to receive(:raw_put).with("#{url}/#{api_version}/#{path}", params: params, headers: headers)
      subject
    end
  end

  describe '.raw_put' do
    subject { instance.raw_put(path, params: params, headers: headers) }
    let(:path) { random }
    let(:params) { Object.new }
    let(:headers) { Object.new }

    it 'sends the PUT request' do
      expect(instance).to receive(:include_api_key!)
      expect(instance).to receive(:include_json_content_type!)
      expect(instance).to receive(:include_json_accept!)
      expect(Faraday).to receive(:put).with(path, params.to_json, headers)
      subject
    end
  end

  describe '.delete' do
    subject { instance.delete(path, params: params, headers: headers) }
    let(:path) { random }
    let(:params) { Object.new }
    let(:headers) { Object.new }

    it 'calls handle_request and raw_delete' do
      expect(instance).to receive(:handle_request).and_yield
      expect(instance).to receive(:raw_delete).with("#{url}/#{api_version}/#{path}", params: params, headers: headers)
      subject
    end
  end

  describe '.raw_delete' do
    subject { instance.raw_delete(path, params: params, headers: headers) }
    let(:path) { random }
    let(:params) { Object.new }
    let(:headers) { Object.new }

    it 'sends the GET request' do
      expect(instance).to receive(:include_api_key!)
      expect(instance).to receive(:include_json_accept!)
      expect(Faraday).to receive(:delete).with(path, params, headers)
      subject
    end
  end

  describe '.include_api_key!' do
    subject { instance.include_api_key!(params) }
    let(:params) { {} }

    it 'adds the api_key to the params' do
      subject
      expect(params).to include :api_key
    end
  end

  describe '.include_json_content_type!' do
    subject { instance.include_json_content_type!(headers) }
    let(:headers) { {} }

    it 'adds the json_content_type to the headers' do
      subject
      expect(headers).to include :'Content-Type'
    end
  end

  describe '.include_json_accept!' do
    subject { instance.include_json_accept!(headers) }
    let(:headers) { {} }

    it 'adds the json_accept to the headers' do
      subject
      expect(headers).to include :Accept
    end
  end

  describe '.handle_request' do
    subject { instance.handle_request { response } }
    let(:response) { {status: status} }
    let(:status) { random }

    before :each do
      expect(instance).to receive(:trim_response).and_return(response)
    end

    context 'when http status is 200' do
      let(:status) { 200 }

      it 'returns the response' do
        expect(subject).to eq response
      end
    end

    context 'when the http status is 404' do
      let(:status) { 404 }

      it 'raises error' do
        expect { subject }.to raise_error(Faraday::Error::ResourceNotFound)
      end
    end

    context 'when the http status is 400' do
      let(:status) { 400 }

      it 'raises error' do
        expect { subject }.to raise_error(Faraday::Error::ClientError)
      end
    end
  end

  describe '.trim_response' do
    subject { instance.trim_response(response) }
    let(:response) { OpenStruct.new(status: status, headers: headers, body: body, foo: random) }
    let(:status) { random }
    let(:headers) { random }
    let(:body) { random }

    it 'returns only desired info' do
      expect(subject[:status]).to eq status
      expect(subject[:headers]).to eq headers
      expect(subject[:body]).to eq body
      expect(subject.keys).to eq [:status, :headers, :body]
    end
  end
end
