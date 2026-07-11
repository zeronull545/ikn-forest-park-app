<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\ForestPark;
use Illuminate\Support\Str;

class ForestParkSeeder extends Seeder
{
    /**
     * Run the database seeds with real & projected IKN Forest Parks.
     */
    public function run(): void
    {
        $parks = [
            [
                'name' => 'Taman Hutan Raya IKN (Tahura IKN)',
                'description' => 'The flagship conservation forest park in Ibu Kota Nusantara, specifically restored with endemic tropical rainforest tree species (Dipterocarpaceae) to preserve the biodiversity of East Kalimantan.',
                'location_coordinate' => '-0.954200,116.712100',
                'area_hectares' => 12500.00,
                'flora_fauna_highlights' => ['Meranti (Shoreae)', 'Ulin (Ironwood)', 'Proboscis Monkey (Bekantan)', 'Hornbill (Rangkong)'],
                'facilities_json' => [
                    'hiking_trails' => true,
                    'canopy_walk' => true,
                    'visitor_center' => true,
                    'camping_ground' => true,
                    'guide_service' => true,
                    'entry_fee_idr' => 20000,
                    'opening_hours' => '07:00 - 17:00'
                ]
            ],
            [
                'name' => 'Sumbu Kebangsaan Botanical Garden',
                'description' => 'An urban botanical garden situated in the heart of the Central Government Core Area (KIPP) in IKN. It serves as a beautiful green lounge, merging state buildings with dense green forest structures.',
                'location_coordinate' => '-0.961100,116.721500',
                'area_hectares' => 120.50,
                'flora_fauna_highlights' => ['Nepenthes (Semar bag)', 'Orchids', 'Butterfly Garden', 'Sun Bear (observed/sheltered)'],
                'facilities_json' => [
                    'hiking_trails' => true,
                    'canopy_walk' => false,
                    'visitor_center' => true,
                    'camping_ground' => false,
                    'guide_service' => true,
                    'entry_fee_idr' => 0, // Free public entry
                    'opening_hours' => '24 Hours'
                ]
            ],
            [
                'name' => 'Bukit Bangkirai Forest Park',
                'description' => 'An active rainforest conservation park famous for its iconic canopy bridge suspended 30 meters above the ground, linking giant Bangkirai trees that are over 150 years old.',
                'location_coordinate' => '-1.026400,116.865500',
                'area_hectares' => 1500.00,
                'flora_fauna_highlights' => ['Bangkirai trees (Shorea laevis)', 'Wild Orchids', 'Gibbons (Owa Kalimantan)', 'Muntjac Deer'],
                'facilities_json' => [
                    'hiking_trails' => true,
                    'canopy_walk' => true,
                    'visitor_center' => true,
                    'camping_ground' => true,
                    'guide_service' => true,
                    'entry_fee_idr' => 35000,
                    'opening_hours' => '08:00 - 16:30'
                ]
            ],
            [
                'name' => 'Mentawir Mangrove Park',
                'description' => 'A serene mangrove conservation park located on the outskirts of the IKN bay area, focusing on protecting crucial coastal ecosystems and offering boat tours through mangrove forests.',
                'location_coordinate' => '-1.042300,116.738100',
                'area_hectares' => 2300.00,
                'flora_fauna_highlights' => ['Rhizophora Mangroves', 'Nipa Palms', 'Mudskippers', 'Estuarine Crocodiles (monitored)'],
                'facilities_json' => [
                    'hiking_trails' => true, // Wooden boardwalks
                    'canopy_walk' => false,
                    'visitor_center' => true,
                    'camping_ground' => false,
                    'guide_service' => true,
                    'entry_fee_idr' => 15000,
                    'opening_hours' => '08:00 - 17:00'
                ]
            ],
            [
                'name' => 'Rimba Eco-Park KIPP',
                'description' => 'A designated green zone surrounding the executive complexes in IKN, keeping the presidential palace immersed in nature. It features outdoor amphitheaters and active micro-climate restoration projects.',
                'location_coordinate' => '-0.963200,116.711800',
                'area_hectares' => 450.00,
                'flora_fauna_highlights' => ['Bamboo Grove', 'Ficus Trees', 'Songbirds', 'Egrets'],
                'facilities_json' => [
                    'hiking_trails' => true,
                    'canopy_walk' => true,
                    'visitor_center' => true,
                    'camping_ground' => false,
                    'guide_service' => false,
                    'entry_fee_idr' => 0,
                    'opening_hours' => '06:00 - 18:00'
                ]
            ]
        ];

        foreach ($parks as $park) {
            ForestPark::updateOrCreate(
                ['slug' => Str::slug($park['name'])],
                [
                    'name' => $park['name'],
                    'description' => $park['description'],
                    'location_coordinate' => $park['location_coordinate'],
                    'area_hectares' => $park['area_hectares'],
                    'flora_fauna_highlights' => $park['flora_fauna_highlights'],
                    'facilities_json' => $park['facilities_json'],
                ]
            );
        }
    }
}
