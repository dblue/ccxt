# -*- coding: utf-8 -*-
# frozen_string_literal: true

# PLEASE DO NOT EDIT THIS FILE, IT IS GENERATED AND WILL BE OVERWRITTEN:
# https://github.com/ccxt/ccxt/blob/master/CONTRIBUTING.md#how-to-contribute-code

require_relative 'fcoin'

module Ccxt
  class Fcoinjp < Fcoin
    def describe
      return self.deep_extend(super, {
        'id' => 'fcoinjp',
        'name' => 'FCoinJP',
        'countries' => ['JP'],
        'hostname' => 'fcoinjp.com',
        'urls' => {
          'logo' => 'https://user-images.githubusercontent.com/1294454/54219174-08b66b00-4500-11e9-862d-f522d0fe08c6.jpg',
          'fees' => 'https://fcoinjp.zendesk.com/hc/en-us/articles/360018727371',
          'www' => 'https://www.fcoinjp.com',
          'referral' => nil
        }
      })
    end
  end
end
