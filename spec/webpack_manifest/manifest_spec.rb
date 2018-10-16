# frozen_string_literal: true

require 'spec_helper'
require 'webpack_manifest/manifest'

RSpec.describe WebpackManifest::Manifest do
  describe '.new' do
    subject { described_class.new(path, cache: cache) }

    let(:path) { 'webpack-assets.json' }
    let(:cache) { true }

    it { is_expected.to be_a described_class }
  end

  describe '#lookup!' do
    subject { described_class.new(path, cache: cache).lookup!(name) }

    let(:path) { File.expand_path('../support/files/manifest.json', __dir__) }
    let(:cache) { false }

    context 'when entry is matched by name' do
      let(:name) { 'test.js' }

      it { is_expected.to eq '/assets/web/pack/test-9a55da116417a39a9d1b.js' }
    end

    context 'when hash is given' do
      let(:path) do
        {
          "item_group_editor.css" => '/packs/item_group_editor-5d7c7164b8a0a9d675fad9ab410eaa8d.css',
        "item_group_editor.js" => '/packs/item_group_editor-857e5bfa272e71b6384046f68ba29d44.js',
        "item_group_editor.js.map" => '/packs/item_group_editor.js.map',
        "union-ok.png" => '/packs/union-ok-857e5bfa272e71b6384046f68ba29d44.png',
        "union-ok@2x.png" => '/packs/union-ok@2x-5d7c7164b8a0a9d675fad9ab410eaa8d.png'
        }
        let(:name) { 'item_group_editor.css' }

        it { is_expected.to eq '/packs/item_group_editor-5d7c7164b8a0a9d675fad9ab410eaa8d.css' }
      end
    end

    context 'when non exit name is given' do
      let(:name) { 'foo' }

      it { expect { subject }.to raise_error WebpackManifest::Manifest::MissingEntryError }
    end
  end
end