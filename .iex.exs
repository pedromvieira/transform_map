m = [%{
  "_ip" => "104.41.40.73",
  "country" => %{
    "alpha3Code" => "BRA",
    "callingCodes" => ["55"],
    "capital" => "Brasília",
    "currencies" => [
      %{"code" => "BRL", "name" => "Brazilian real", "symbol" => "R$"},
      %{"code" => "BRL", "name" => "Brazilian real", "symbol" => "R$"}
    ],
    "flag" => "https://restcountries.eu/data/bra.svg",
    "languages" => [
      %{
        "iso639_1" => "pt",
        "iso639_2" => "por",
        "name" => "Portuguese",
        "nativeName" => "Português"
      }
    ],
    "latlng" => [-10.0, -55.0],
    "name" => "Brazil",
    "nativeName" => "Brasil",
    "region" => "Americas",
    "regionalBlocs" => [
      %{
        "acronym" => "USAN",
        "name" => "Union of South American Nations",
        "otherAcronyms" => ["UNASUR", "UNASUL", "UZAN"],
        "otherNames" => ["Unión de Naciones Suramericanas",
         "União de Nações Sul-Americanas",
         "Unie van Zuid-Amerikaanse Naties", "South American Union"]
      }
    ],
    "subregion" => "South America",
    "timezones" => ["UTC-05:00", "UTC-04:00", "UTC-03:00", "UTC-02:00"],
    "topLevelDomain" => [".br"]
  },
  "data" => %{
    "city" => %{
      "geoname_id" => 3467865,
      "names" => %{
        "de" => "Campinas",
        "en" => "Campinas",
        "es" => "Campinas",
        "fr" => "Campinas",
        "ja" => "カンピーナス",
        "pt-BR" => "Campinas",
        "ru" => "Кампинас",
        "zh-CN" => "坎皮纳斯"
      }
    },
    "continent" => %{
      "code" => "SA",
      "geoname_id" => 6255150,
      "names" => %{
        "de" => "Südamerika",
        "en" => "South America",
        "es" => "Sudamérica",
        "fr" => "Amérique du Sud",
        "ja" => "南アメリカ",
        "pt-BR" => "América do Sul",
        "ru" => "Южная Америка",
        "zh-CN" => "南美洲"
      }
    },
    "country" => %{
      "geoname_id" => 3469034,
      "iso_code" => "BR",
      "names" => %{
        "de" => "Brasilien",
        "en" => "Brazil",
        "es" => "Brasil",
        "fr" => "Brésil",
        "ja" => "ブラジル連邦共和国",
        "pt-BR" => "Brasil",
        "ru" => "Бразилия",
        "zh-CN" => "巴西"
      }
    },
    "location" => %{
      "accuracy_radius" => 1000,
      "latitude" => -22.9095,
      "longitude" => -47.0674,
      "time_zone" => "America/Sao_Paulo"
    },
    "registered_country" => %{
      "geoname_id" => 6252001,
      "iso_code" => "US",
      "names" => %{
        "de" => "USA",
        "en" => "United States",
        "es" => "Estados Unidos",
        "fr" => "États-Unis",
        "ja" => "アメリカ合衆国",
        "pt-BR" => "Estados Unidos",
        "ru" => "США",
        "zh-CN" => "美国"
      }
    },
    "subdivisions" => [
      %{
        "geoname_id" => 3448433,
        "iso_code" => "SP",
        "names" => %{
          "en" => "Sao Paulo",
          "es" => "São Paulo",
          "pt-BR" => "São Paulo"
        }
      },
      %{
        "geoname_id" => 3448433,
        "iso_code" => "SP",
        "names" => %{
          "en" => "Sao Paulo",
          "es" => "São Paulo",
          "pt-BR" => "São Paulo"
        }
      }
    ],
    "traits" => %{
      "autonomous_system_number" => 8075,
      "autonomous_system_organization" => "Microsoft Corporation",
      "ip_address" => "104.41.40.73",
      "isp" => "Microsoft Corporation",
      "organization" => "Microsoft Azure"
    }
  },
  "quantity" => 8245,
  "updated_at" => "2018-04-27 18:51:08.671029"
}]
s = m |> TransformMap.multiple_shrink()