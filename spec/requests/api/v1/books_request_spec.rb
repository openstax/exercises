require 'vcr_helper'

RSpec.describe Api::V1::BooksController, type: :request, api: :true, version: :v1, vcr: VCR_OPTS do
  let(:user)       { FactoryBot.create :user, :agreed_to_terms }
  let(:user_token) { FactoryBot.create :doorkeeper_access_token, resource_owner_id: user.id }

  context '#index' do
    it 'returns a list of books in the latest archive version' do
      api_get api_books_url, user_token
      expect(response).to have_http_status(:ok)

      expect(JSON.parse body).to eq(
        [
          {
            "uuid" => "405335a3-7cff-4df2-a9ad-29062a4af261",
            "version" => "8.46",
            "title" => "College Physics Courseware",
            "slug" => "college-physics-courseware"
          },
          {
            "uuid" => "36004586-651c-4ded-af87-203aca22d946",
            "version" => "14.3",
            "title" => "Life Liberty And Pursuit Happiness",
            "slug" => "life-liberty-and-pursuit-happiness"
          },
          {
            "uuid" => "728df0bb-e07f-489d-91e3-4734a5932f92",
            "version" => "1.17",
            "title" => "Psychologia",
            "slug" => "Psychologia"
          },
          {
            "uuid" => "4eaa8f03-88a8-485a-a777-dd3602f6c13e",
            "version" => "4.14",
            "title" => "Fizyka Dla Szkół Wyższych Tom 1",
            "slug" => "fizyka-dla-szkół-wyższych-tom-1"
          },
          {
            "uuid" => "16ab5b96-4598-45f9-993c-b8d78d82b0c6",
            "version" => "5.1",
            "title" => "Fizyka Dla Szkół Wyższych Tom 2",
            "slug" => "fizyka-dla-szkół-wyższych-tom-2"
          },
          {
            "uuid" => "bb62933e-f20a-4ffc-90aa-97b36c296c3e",
            "version" => "6.23",
            "title" => "Fizyka Dla Szkół Wyższych Tom 3",
            "slug" => "fizyka-dla-szkół-wyższych-tom-3"
          },
          {
            "uuid" => "13ac107a-f15f-49d2-97e8-60ab2e3b519c",
            "version" => "33.3",
            "title" => "Algebra And Trigonometry",
            "slug" => "algebra-and-trigonometry"
          },
          {
            "uuid" => "5bcc0e59-7345-421d-8507-a1e4608685e8",
            "version" => "19.1",
            "title" => "American Government",
            "slug" => "american-government"
          },
          {
            "uuid" => "9d8df601-4f12-4ac1-8224-b450bf739e5f",
            "version" => "6.7",
            "title" => "American Government 2e",
            "slug" => "american-government-2e"
          },
          {
            "uuid" => "14fb4ad7-39a1-4eee-ab6e-3ef2482e3e22",
            "version" => "22.8",
            "title" => "Anatomy And Physiology",
            "slug" => "anatomy-and-physiology"
          },
          {
            "uuid" => "2e737be8-ea65-48c3-aa0a-9f35b4c6a966",
            "version" => "22.49",
            "title" => "Astronomy",
            "slug" => "astronomy"
          },
          {
            "uuid" => "185cbf87-c72e-48f5-b51e-f14f21b5eabd",
            "version" => "14.1",
            "title" => "Biology",
            "slug" => "biology"
          },
          {
            "uuid" => "8d50a0af-948b-4204-a71d-4826cba765b8",
            "version" => "16.179",
            "title" => "Biology 2e",
            "slug" => "biology-2e"
          },
          {
            "uuid" => "6c322e32-9fb0-4c4d-a1d7-20c95c5c7af2",
            "version" => "26.26",
            "title" => "Biology Ap Courses",
            "slug" => "biology-ap-courses"
          },
          {
            "uuid" => "914ac66e-e1ec-486d-8a9c-97b0f7a99774",
            "version" => "5.14",
            "title" => "Business Ethics",
            "slug" => "business-ethics"
          },
          {
            "uuid" => "464a3fba-68c1-426a-99f9-597e739dc911",
            "version" => "8.9",
            "title" => "Business Law I Essentials",
            "slug" => "business-law-i-essentials"
          },
          {
            "uuid" => "8b89d172-2927-466f-8661-01abc7ccdba4",
            "version" => "22.2",
            "title" => "Calculus Volume 1",
            "slug" => "calculus-volume-1"
          },
          {
            "uuid" => "1d39a348-071f-4537-85b6-c98912458c3c",
            "version" => "22.1",
            "title" => "Calculus Volume 2",
            "slug" => "calculus-volume-2"
          },
          {
            "uuid" => "a31cd793-2162-4e9e-acb5-6e6bbd76a5fa",
            "version" => "22.1",
            "title" => "Calculus Volume 3",
            "slug" => "calculus-volume-3"
          },
          {
            "uuid" => "85abf193-2bd2-4908-8563-90b8a7ac8df6",
            "version" => "13.1",
            "title" => "Chemistry",
            "slug" => "chemistry"
          },
          {
            "uuid" => "7fccc9cf-9b71-44f6-800b-f9457fd64335",
            "version" => "18.36",
            "title" => "Chemistry 2e",
            "slug" => "chemistry-2e"
          },
          {
            "uuid" => "d9b85ee6-c57f-4861-8208-5ddf261e9c5f",
            "version" => "14.36",
            "title" => "Chemistry Atoms First 2e",
            "slug" => "chemistry-atoms-first-2e"
          },
          {
            "uuid" => "4539ae23-1ccc-421e-9b25-843acbb6c4b0",
            "version" => "10.1",
            "title" => "Chemistry Atoms First",
            "slug" => "chemistry-atoms-first"
          },
          {
            "uuid" => "9b08c294-057f-4201-9f48-5d6ad992740d",
            "version" => "32.2",
            "title" => "College Algebra",
            "slug" => "college-algebra"
          },
          {
            "uuid" => "507feb1e-cfff-4b54-bc07-d52636cecfe3",
            "version" => "10.2",
            "title" => "College Algebra Corequisite Support",
            "slug" => "college-algebra-corequisite-support"
          },
          {
            "uuid" => "031da8d3-b525-429c-80cf-6c8ed997733a",
            "version" => "23.18",
            "title" => "College Physics",
            "slug" => "college-physics"
          },
          {
            "uuid" => "8d04a686-d5e8-4798-a27d-c608e4d0e187",
            "version" => "35.2",
            "title" => "College Physics Ap Courses",
            "slug" => "college-physics-ap-courses"
          },
          {
            "uuid" => "e8668a14-9a7d-4d74-b58c-3681f8351224",
            "version" => "10.2",
            "title" => "College Success",
            "slug" => "college-success"
          },
          {
            "uuid" => "b3c1e1d2-839c-42b0-a314-e119a8aafbdd",
            "version" => "17.23",
            "title" => "Concepts Biology",
            "slug" => "concepts-biology"
          },
          {
            "uuid" => "0889907c-f0ef-496a-bcb8-2a5bb121717f",
            "version" => "9.3",
            "title" => "Elementary Algebra",
            "slug" => "elementary-algebra"
          },
          {
            "uuid" => "55931856-c627-418b-a56f-1dd0007683a8",
            "version" => "9.3",
            "title" => "Elementary Algebra 2e",
            "slug" => "elementary-algebra-2e"
          },
          {
            "uuid" => "d380510e-6145-4625-b19a-4fa68204b6b1",
            "version" => "12.7",
            "title" => "Entrepreneurship",
            "slug" => "entrepreneurship"
          },
          {
            "uuid" => "02776133-d49d-49cb-bfaa-67c7f61b25a1",
            "version" => "14.1",
            "title" => "Intermediate Algebra",
            "slug" => "intermediate-algebra"
          },
          {
            "uuid" => "4664c267-cd62-4a99-8b28-1cb9b3aee347",
            "version" => "7.2",
            "title" => "Intermediate Algebra 2e",
            "slug" => "intermediate-algebra-2e"
          },
          {
            "uuid" => "4e09771f-a8aa-40ce-9063-aa58cc24e77f",
            "version" => "9.8",
            "title" => "Introduction Business",
            "slug" => "introduction-business"
          },
          {
            "uuid" => "1b4ee0ce-ee89-44fa-a5e7-a0db9f0c94b1",
            "version" => "6.21",
            "title" => "Introduction Intellectual Property",
            "slug" => "introduction-intellectual-property"
          },
          {
            "uuid" => "afe4332a-c97f-4fc4-be27-4e4d384a32d8",
            "version" => "18.1",
            "title" => "Introduction Sociology",
            "slug" => "introduction-sociology"
          },
          {
            "uuid" => "02040312-72c8-441e-a685-20e9333f3e1d",
            "version" => "15.10",
            "title" => "Introduction Sociology 2e",
            "slug" => "introduction-sociology-2e"
          },
          {
            "uuid" => "746f171e-0d6a-4ef2-b69d-367880872f4a",
            "version" => "3.19",
            "title" => "Introduction To Sociology 3e",
            "slug" => "introduction-to-sociology-3e"
          },
          {
            "uuid" => "b56bb9e9-5eb8-48ef-9939-88b1b12ce22f",
            "version" => "38.24",
            "title" => "Introductory Business Statistics",
            "slug" => "introductory-business-statistics"
          },
          {
            "uuid" => "30189442-6998-4686-ac05-ed152b91b9de",
            "version" => "25.23",
            "title" => "Introductory Statistics",
            "slug" => "introductory-statistics"
          },
          {
            "uuid" => "e42bd376-624b-4c0f-972f-e0c57998e765",
            "version" => "9.13",
            "title" => "Microbiology",
            "slug" => "microbiology"
          },
          {
            "uuid" => "2d941ab9-ac5b-4eb8-b21c-965d36a4f296",
            "version" => "9.8",
            "title" => "Organizational Behavior",
            "slug" => "organizational-behavior"
          },
          {
            "uuid" => "cce64fde-f448-43b8-ae88-27705cceb0da",
            "version" => "14.21",
            "title" => "Physics",
            "slug" => "physics"
          },
          {
            "uuid" => "caa57dab-41c7-455e-bd6f-f443cda5519c",
            "version" => "21.1",
            "title" => "Prealgebra",
            "slug" => "prealgebra"
          },
          {
            "uuid" => "f0fa90be-fca8-43c9-9aad-715c0a2cee2b",
            "version" => "11.2",
            "title" => "Prealgebra 2e",
            "slug" => "prealgebra-2e"
          },
          {
            "uuid" => "fd53eae1-fa23-47c7-bb1b-972349835c3c",
            "version" => "36.3",
            "title" => "Precalculus",
            "slug" => "precalculus"
          },
          {
            "uuid" => "9ab4ba6d-1e48-486d-a2de-38ae1617ca84",
            "version" => "7.8",
            "title" => "Principles Financial Accounting",
            "slug" => "principles-financial-accounting"
          },
          {
            "uuid" => "920d1c8a-606c-4888-bfd4-d1ee27ce1795",
            "version" => "18.1",
            "title" => "Principles Managerial Accounting",
            "slug" => "principles-managerial-accounting"
          },
          {
            "uuid" => "69619d2b-68f0-44b0-b074-a9b2bf90b2c6",
            "version" => "12.4",
            "title" => "Principles Economics",
            "slug" => "principles-economics"
          },
          {
            "uuid" => "bc498e1f-efe9-43a0-8dea-d3569ad09a82",
            "version" => "12.4",
            "title" => "Principles Economics 2e",
            "slug" => "principles-economics-2e"
          },
          {
            "uuid" => "4061c832-098e-4b3c-a1d9-7eb593a2cb31",
            "version" => "13.2",
            "title" => "Principles Macroeconomics",
            "slug" => "principles-macroeconomics"
          },
          {
            "uuid" => "27f59064-990e-48f1-b604-5188b9086c29",
            "version" => "16.1",
            "title" => "Principles Macroeconomics 2e",
            "slug" => "principles-macroeconomics-2e"
          },
          {
            "uuid" => "33076054-ec1d-4417-8824-ce354efe42d0",
            "version" => "4.2",
            "title" => "Principles Macroeconomics Ap Courses",
            "slug" => "principles-macroeconomics-ap-courses"
          },
          {
            "uuid" => "9117cf8c-a8a3-4875-8361-9cb0f1fc9362",
            "version" => "15.1",
            "title" => "Principles Macroeconomics Ap Courses 2e",
            "slug" => "principles-macroeconomics-ap-courses-2e"
          },
          {
            "uuid" => "c3acb2ab-7d5c-45ad-b3cd-e59673fedd4e",
            "version" => "12.8",
            "title" => "Principles Management",
            "slug" => "principles-management"
          },
          {
            "uuid" => "ea2f225e-6063-41ca-bcd8-36482e15ef65",
            "version" => "13.3",
            "title" => "Principles Microeconomics",
            "slug" => "principles-microeconomics"
          },
          {
            "uuid" => "5c09762c-b540-47d3-9541-dda1f44f16e5",
            "version" => "19.1",
            "title" => "Principles Microeconomics 2e",
            "slug" => "principles-microeconomics-2e"
          },
          {
            "uuid" => "ca344e2d-6731-43cd-b851-a7b3aa0b37aa",
            "version" => "7.1",
            "title" => "Principles Microeconomics Ap Courses",
            "slug" => "principles-microeconomics-ap-courses"
          },
          {
            "uuid" => "636cbfd9-4e37-4575-83ab-9dec9029ca4e",
            "version" => "15.1",
            "title" => "Principles Microeconomics Ap Courses 2e",
            "slug" => "principles-microeconomics-ap-courses-2e"
          },
          {
            "uuid" => "4abf04bf-93a0-45c3-9cbc-2cefd46e68cc",
            "version" => "13.2",
            "title" => "Psychology",
            "slug" => "psychology"
          },
          {
            "uuid" => "06aba565-9432-40f6-97ee-b8a361f118a8",
            "version" => "4.18",
            "title" => "Psychology 2e",
            "slug" => "psychology-2e"
          },
          {
            "uuid" => "394a1101-fd8f-4875-84fa-55f15b06ba66",
            "version" => "8.19",
            "title" => "Statistics",
            "slug" => "statistics"
          },
          {
            "uuid" => "a7ba2fb8-8925-4987-b182-5f4429d48daa",
            "version" => "10.21",
            "title" => "Us History",
            "slug" => "us-history"
          },
          {
            "uuid" => "d50f6e32-0fda-46ef-a362-9bd36ca7c97d",
            "version" => "22.3",
            "title" => "University Physics Volume 1",
            "slug" => "university-physics-volume-1"
          },
          {
            "uuid" => "7a0f9770-1c44-4acd-9920-1cd9a99f2a1e",
            "version" => "27.1",
            "title" => "University Physics Volume 2",
            "slug" => "university-physics-volume-2"
          },
          {
            "uuid" => "af275420-6050-4707-995c-57b9cc13c358",
            "version" => "22.5",
            "title" => "University Physics Volume 3",
            "slug" => "university-physics-volume-3"
          }
        ]
      )
    end

    it 'returns a list of books in a given archive version' do
      api_get api_books_url(archive_version: '20210421.141058'), user_token
      expect(response).to have_http_status(:ok)

      expect(JSON.parse body).to eq(
        [
          {
            "uuid" => "405335a3-7cff-4df2-a9ad-29062a4af261",
            "version" => "8.46",
            "title" => "College Physics Courseware",
            "slug" => "college-physics-courseware"
          },
          {
            "uuid" => "36004586-651c-4ded-af87-203aca22d946",
            "version" => "14.3",
            "title" => "Life Liberty And Pursuit Happiness",
            "slug" => "life-liberty-and-pursuit-happiness"
          },
          {
            "uuid" => "728df0bb-e07f-489d-91e3-4734a5932f92",
            "version" => "1.17",
            "title" => "Psychologia",
            "slug" => "Psychologia"
          },
          {
            "uuid" => "4eaa8f03-88a8-485a-a777-dd3602f6c13e",
            "version" => "4.14",
            "title" => "Fizyka Dla Szkół Wyższych Tom 1",
            "slug" => "fizyka-dla-szkół-wyższych-tom-1"
          },
          {
            "uuid" => "16ab5b96-4598-45f9-993c-b8d78d82b0c6",
            "version" => "5.1",
            "title" => "Fizyka Dla Szkół Wyższych Tom 2",
            "slug" => "fizyka-dla-szkół-wyższych-tom-2"
          },
          {
            "uuid" => "bb62933e-f20a-4ffc-90aa-97b36c296c3e",
            "version" => "6.23",
            "title" => "Fizyka Dla Szkół Wyższych Tom 3",
            "slug" => "fizyka-dla-szkół-wyższych-tom-3"
          },
          {
            "uuid" => "13ac107a-f15f-49d2-97e8-60ab2e3b519c",
            "version" => "33.3",
            "title" => "Algebra And Trigonometry",
            "slug" => "algebra-and-trigonometry"
          },
          {
            "uuid" => "5bcc0e59-7345-421d-8507-a1e4608685e8",
            "version" => "19.1",
            "title" => "American Government",
            "slug" => "american-government"
          },
          {
            "uuid" => "9d8df601-4f12-4ac1-8224-b450bf739e5f",
            "version" => "6.7",
            "title" => "American Government 2e",
            "slug" => "american-government-2e"
          },
          {
            "uuid" => "14fb4ad7-39a1-4eee-ab6e-3ef2482e3e22",
            "version" => "22.8",
            "title" => "Anatomy And Physiology",
            "slug" => "anatomy-and-physiology"
          },
          {
            "uuid" => "2e737be8-ea65-48c3-aa0a-9f35b4c6a966",
            "version" => "22.49",
            "title" => "Astronomy",
            "slug" => "astronomy"
          },
          {
            "uuid" => "185cbf87-c72e-48f5-b51e-f14f21b5eabd",
            "version" => "14.1",
            "title" => "Biology",
            "slug" => "biology"
          },
          {
            "uuid" => "8d50a0af-948b-4204-a71d-4826cba765b8",
            "version" => "16.179",
            "title" => "Biology 2e",
            "slug" => "biology-2e"
          },
          {
            "uuid" => "6c322e32-9fb0-4c4d-a1d7-20c95c5c7af2",
            "version" => "26.26",
            "title" => "Biology Ap Courses",
            "slug" => "biology-ap-courses"
          },
          {
            "uuid" => "914ac66e-e1ec-486d-8a9c-97b0f7a99774",
            "version" => "5.14",
            "title" => "Business Ethics",
            "slug" => "business-ethics"
          },
          {
            "uuid" => "464a3fba-68c1-426a-99f9-597e739dc911",
            "version" => "8.9",
            "title" => "Business Law I Essentials",
            "slug" => "business-law-i-essentials"
          },
          {
            "uuid" => "8b89d172-2927-466f-8661-01abc7ccdba4",
            "version" => "22.2",
            "title" => "Calculus Volume 1",
            "slug" => "calculus-volume-1"
          },
          {
            "uuid" => "1d39a348-071f-4537-85b6-c98912458c3c",
            "version" => "22.1",
            "title" => "Calculus Volume 2",
            "slug" => "calculus-volume-2"
          },
          {
            "uuid" => "a31cd793-2162-4e9e-acb5-6e6bbd76a5fa",
            "version" => "22.1",
            "title" => "Calculus Volume 3",
            "slug" => "calculus-volume-3"
          },
          {
            "uuid" => "85abf193-2bd2-4908-8563-90b8a7ac8df6",
            "version" => "13.1",
            "title" => "Chemistry",
            "slug" => "chemistry"
          },
          {
            "uuid" => "7fccc9cf-9b71-44f6-800b-f9457fd64335",
            "version" => "18.36",
            "title" => "Chemistry 2e",
            "slug" => "chemistry-2e"
          },
          {
            "uuid" => "d9b85ee6-c57f-4861-8208-5ddf261e9c5f",
            "version" => "14.36",
            "title" => "Chemistry Atoms First 2e",
            "slug" => "chemistry-atoms-first-2e"
          },
          {
            "uuid" => "4539ae23-1ccc-421e-9b25-843acbb6c4b0",
            "version" => "10.1",
            "title" => "Chemistry Atoms First",
            "slug" => "chemistry-atoms-first"
          },
          {
            "uuid" => "9b08c294-057f-4201-9f48-5d6ad992740d",
            "version" => "32.2",
            "title" => "College Algebra",
            "slug" => "college-algebra"
          },
          {
            "uuid" => "507feb1e-cfff-4b54-bc07-d52636cecfe3",
            "version" => "10.2",
            "title" => "College Algebra Corequisite Support",
            "slug" => "college-algebra-corequisite-support"
          },
          {
            "uuid" => "031da8d3-b525-429c-80cf-6c8ed997733a",
            "version" => "23.18",
            "title" => "College Physics",
            "slug" => "college-physics"
          },
          {
            "uuid" => "8d04a686-d5e8-4798-a27d-c608e4d0e187",
            "version" => "35.2",
            "title" => "College Physics Ap Courses",
            "slug" => "college-physics-ap-courses"
          },
          {
            "uuid" => "e8668a14-9a7d-4d74-b58c-3681f8351224",
            "version" => "10.2",
            "title" => "College Success",
            "slug" => "college-success"
          },
          {
            "uuid" => "b3c1e1d2-839c-42b0-a314-e119a8aafbdd",
            "version" => "17.23",
            "title" => "Concepts Biology",
            "slug" => "concepts-biology"
          },
          {
            "uuid" => "0889907c-f0ef-496a-bcb8-2a5bb121717f",
            "version" => "9.3",
            "title" => "Elementary Algebra",
            "slug" => "elementary-algebra"
          },
          {
            "uuid" => "55931856-c627-418b-a56f-1dd0007683a8",
            "version" => "9.3",
            "title" => "Elementary Algebra 2e",
            "slug" => "elementary-algebra-2e"
          },
          {
            "uuid" => "d380510e-6145-4625-b19a-4fa68204b6b1",
            "version" => "12.7",
            "title" => "Entrepreneurship",
            "slug" => "entrepreneurship"
          },
          {
            "uuid" => "02776133-d49d-49cb-bfaa-67c7f61b25a1",
            "version" => "14.1",
            "title" => "Intermediate Algebra",
            "slug" => "intermediate-algebra"
          },
          {
            "uuid" => "4664c267-cd62-4a99-8b28-1cb9b3aee347",
            "version" => "7.2",
            "title" => "Intermediate Algebra 2e",
            "slug" => "intermediate-algebra-2e"
          },
          {
            "uuid" => "4e09771f-a8aa-40ce-9063-aa58cc24e77f",
            "version" => "9.8",
            "title" => "Introduction Business",
            "slug" => "introduction-business"
          },
          {
            "uuid" => "1b4ee0ce-ee89-44fa-a5e7-a0db9f0c94b1",
            "version" => "6.21",
            "title" => "Introduction Intellectual Property",
            "slug" => "introduction-intellectual-property"
          },
          {
            "uuid" => "afe4332a-c97f-4fc4-be27-4e4d384a32d8",
            "version" => "18.1",
            "title" => "Introduction Sociology",
            "slug" => "introduction-sociology"
          },
          {
            "uuid" => "02040312-72c8-441e-a685-20e9333f3e1d",
            "version" => "15.10",
            "title" => "Introduction Sociology 2e",
            "slug" => "introduction-sociology-2e"
          },
          {
            "uuid" => "746f171e-0d6a-4ef2-b69d-367880872f4a",
            "version" => "3.19",
            "title" => "Introduction To Sociology 3e",
            "slug" => "introduction-to-sociology-3e"
          },
          {
            "uuid" => "b56bb9e9-5eb8-48ef-9939-88b1b12ce22f",
            "version" => "38.24",
            "title" => "Introductory Business Statistics",
            "slug" => "introductory-business-statistics"
          },
          {
            "uuid" => "30189442-6998-4686-ac05-ed152b91b9de",
            "version" => "25.23",
            "title" => "Introductory Statistics",
            "slug" => "introductory-statistics"
          },
          {
            "uuid" => "e42bd376-624b-4c0f-972f-e0c57998e765",
            "version" => "9.13",
            "title" => "Microbiology",
            "slug" => "microbiology"
          },
          {
            "uuid" => "2d941ab9-ac5b-4eb8-b21c-965d36a4f296",
            "version" => "9.8",
            "title" => "Organizational Behavior",
            "slug" => "organizational-behavior"
          },
          {
            "uuid" => "cce64fde-f448-43b8-ae88-27705cceb0da",
            "version" => "14.21",
            "title" => "Physics",
            "slug" => "physics"
          },
          {
            "uuid" => "caa57dab-41c7-455e-bd6f-f443cda5519c",
            "version" => "21.1",
            "title" => "Prealgebra",
            "slug" => "prealgebra"
          },
          {
            "uuid" => "f0fa90be-fca8-43c9-9aad-715c0a2cee2b",
            "version" => "11.2",
            "title" => "Prealgebra 2e",
            "slug" => "prealgebra-2e"
          },
          {
            "uuid" => "fd53eae1-fa23-47c7-bb1b-972349835c3c",
            "version" => "36.3",
            "title" => "Precalculus",
            "slug" => "precalculus"
          },
          {
            "uuid" => "9ab4ba6d-1e48-486d-a2de-38ae1617ca84",
            "version" => "7.8",
            "title" => "Principles Financial Accounting",
            "slug" => "principles-financial-accounting"
          },
          {
            "uuid" => "920d1c8a-606c-4888-bfd4-d1ee27ce1795",
            "version" => "18.1",
            "title" => "Principles Managerial Accounting",
            "slug" => "principles-managerial-accounting"
          },
          {
            "uuid" => "69619d2b-68f0-44b0-b074-a9b2bf90b2c6",
            "version" => "12.4",
            "title" => "Principles Economics",
            "slug" => "principles-economics"
          },
          {
            "uuid" => "bc498e1f-efe9-43a0-8dea-d3569ad09a82",
            "version" => "12.4",
            "title" => "Principles Economics 2e",
            "slug" => "principles-economics-2e"
          },
          {
            "uuid" => "4061c832-098e-4b3c-a1d9-7eb593a2cb31",
            "version" => "13.2",
            "title" => "Principles Macroeconomics",
            "slug" => "principles-macroeconomics"
          },
          {
            "uuid" => "27f59064-990e-48f1-b604-5188b9086c29",
            "version" => "16.1",
            "title" => "Principles Macroeconomics 2e",
            "slug" => "principles-macroeconomics-2e"
          },
          {
            "uuid" => "33076054-ec1d-4417-8824-ce354efe42d0",
            "version" => "4.2",
            "title" => "Principles Macroeconomics Ap Courses",
            "slug" => "principles-macroeconomics-ap-courses"
          },
          {
            "uuid" => "9117cf8c-a8a3-4875-8361-9cb0f1fc9362",
            "version" => "15.1",
            "title" => "Principles Macroeconomics Ap Courses 2e",
            "slug" => "principles-macroeconomics-ap-courses-2e"
          },
          {
            "uuid" => "c3acb2ab-7d5c-45ad-b3cd-e59673fedd4e",
            "version" => "12.8",
            "title" => "Principles Management",
            "slug" => "principles-management"
          },
          {
            "uuid" => "ea2f225e-6063-41ca-bcd8-36482e15ef65",
            "version" => "13.3",
            "title" => "Principles Microeconomics",
            "slug" => "principles-microeconomics"
          },
          {
            "uuid" => "5c09762c-b540-47d3-9541-dda1f44f16e5",
            "version" => "19.1",
            "title" => "Principles Microeconomics 2e",
            "slug" => "principles-microeconomics-2e"
          },
          {
            "uuid" => "ca344e2d-6731-43cd-b851-a7b3aa0b37aa",
            "version" => "7.1",
            "title" => "Principles Microeconomics Ap Courses",
            "slug" => "principles-microeconomics-ap-courses"
          },
          {
            "uuid" => "636cbfd9-4e37-4575-83ab-9dec9029ca4e",
            "version" => "15.1",
            "title" => "Principles Microeconomics Ap Courses 2e",
            "slug" => "principles-microeconomics-ap-courses-2e"
          },
          {
            "uuid" => "4abf04bf-93a0-45c3-9cbc-2cefd46e68cc",
            "version" => "13.2",
            "title" => "Psychology",
            "slug" => "psychology"
          },
          {
            "uuid" => "06aba565-9432-40f6-97ee-b8a361f118a8",
            "version" => "4.18",
            "title" => "Psychology 2e",
            "slug" => "psychology-2e"
          },
          {
            "uuid" => "394a1101-fd8f-4875-84fa-55f15b06ba66",
            "version" => "8.19",
            "title" => "Statistics",
            "slug" => "statistics"
          },
          {
            "uuid" => "a7ba2fb8-8925-4987-b182-5f4429d48daa",
            "version" => "10.21",
            "title" => "Us History",
            "slug" => "us-history"
          },
          {
            "uuid" => "d50f6e32-0fda-46ef-a362-9bd36ca7c97d",
            "version" => "22.3",
            "title" => "University Physics Volume 1",
            "slug" => "university-physics-volume-1"
          },
          {
            "uuid" => "7a0f9770-1c44-4acd-9920-1cd9a99f2a1e",
            "version" => "27.1",
            "title" => "University Physics Volume 2",
            "slug" => "university-physics-volume-2"
          },
          {
            "uuid" => "af275420-6050-4707-995c-57b9cc13c358",
            "version" => "22.5",
            "title" => "University Physics Volume 3",
            "slug" => "university-physics-volume-3"
          }
        ]
      )
    end
  end

  context '#show' do
    it 'returns a list of pages in the latest book version' do
      api_get api_book_url(uuid: '02040312-72c8-441e-a685-20e9333f3e1d'), user_token
      expect(response).to have_http_status(:ok)

      expect(JSON.parse body).to eq [
        {
          "id" => "325e4afd-80b6-44dd-87b6-35aff4f40eac@",
          "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Preface</span>",
          "slug" => "preface"
        },
        {
          "id" => "795b15c3-7366-5a29-a985-54798220668d@247752b",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>1</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">An Introduction to Sociology</span>",
          "contents" => [
            {
              "id" => "4eb21133-cf0a-4ea7-81f5-b1e47698ec30@",
              "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Sociology</span>",
              "slug" => "1-introduction-to-sociology"
            },
            {
              "id" => "5d97ba77-626b-4670-a1bb-c65fdd07bb0c@",
              "title" => "<span class=\"os-number\">1.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">What Is Sociology?</span>",
              "slug" => "1-1-what-is-sociology"
            },
            {
              "id" => "82966abb-ebb0-48ab-8576-a52a0e126bd9@",
              "title" => "<span class=\"os-number\">1.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The History of Sociology</span>",
              "slug" => "1-2-the-history-of-sociology"
            },
            {
              "id" => "40c45f23-6a75-414a-987a-cccd50bd04b8@",
              "title" => "<span class=\"os-number\">1.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theoretical Perspectives</span>",
              "slug" => "1-3-theoretical-perspectives"
            },
            {
              "id" => "2478dd75-fc23-48c8-9dfc-57a409d04c6b@",
              "title" => "<span class=\"os-number\">1.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Why Study Sociology?</span>",
              "slug" => "1-4-why-study-sociology"
            },
            {
              "id" => "13e975b8-eccc-55a8-b401-a3b43600dd24@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "slug" => "1-key-terms"
            },
            {
              "id" => "2fd5c0d2-f29a-5919-b6f3-c098f794a9d1@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "slug" => "1-section-summary"
            },
            {
              "id" => "caee6ed8-d0d7-57d2-9696-6a9c1c3a79e2@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "slug" => "1-section-quiz"
            },
            {
              "id" => "2a7f9a21-f0d1-5513-9956-57d65efb10c7@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "slug" => "1-short-answer"
            },
            {
              "id" => "c42480ad-12a1-5d9a-bb93-127b0efec627@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "slug" => "1-further-research"
            },
            {
              "id" => "8348c301-f6bc-52e1-b610-2b6721532d87@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "slug" => "1-references"
            }
          ],
          "slug" => "1-an-introduction-to-sociology"
        },
        {
          "id" => "1a4510e8-d047-5d5a-916f-37ae18a04b1d@247752b",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>2</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Sociological Research</span>",
          "contents" => [
            {
              "id" => "de329f8c-7690-4ea5-a3a4-d0ce6605d0ea@",
              "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Sociological Research</span>",
              "slug" => "2-introduction-to-sociological-research"
            },
            {
              "id" => "baee4db6-1e28-43f9-a0b7-a4f3c7263598@",
              "title" => "<span class=\"os-number\">2.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Approaches to Sociological Research</span>",
              "slug" => "2-1-approaches-to-sociological-research"
            },
            {
              "id" => "e72e915a-719d-4496-ac15-5197a2c11258@",
              "title" => "<span class=\"os-number\">2.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Research Methods</span>",
              "slug" => "2-2-research-methods"
            },
            {
              "id" => "6d922c72-61cf-4f13-9b00-4f0c640cbf17@",
              "title" => "<span class=\"os-number\">2.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Ethical Concerns</span>",
              "slug" => "2-3-ethical-concerns"
            },
            {
              "id" => "0b68696a-c5d6-555a-b3aa-c0cfaee872cc@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "slug" => "2-key-terms"
            },
            {
              "id" => "bae1ab4a-0967-5237-8ae3-d0a929f73337@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "slug" => "2-section-summary"
            },
            {
              "id" => "eabe5ac5-3b18-531c-828f-cc6e28366464@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "slug" => "2-section-quiz"
            },
            {
              "id" => "68020c4d-2398-543c-9924-c8dd64ff48ed@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "slug" => "2-short-answer"
            },
            {
              "id" => "7d3e66c5-eaeb-5e95-a0f7-ad3a613e587a@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "slug" => "2-further-research"
            },
            {
              "id" => "c8a34847-9909-535e-a6da-cf48bea2a411@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "slug" => "2-references"
            }
          ],
          "slug" => "2-sociological-research"
        },
        {
          "id" => "c3aebdad-a315-5d48-ba72-22915a58b2cf@247752b",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>3</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Culture</span>",
          "contents" => [
            {
              "id" => "8a8ed60b-fb85-463f-a002-b48af257f894@",
              "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Culture</span>",
              "slug" => "3-introduction-to-culture"
            },
            {
              "id" => "f87398b0-553a-4538-959d-15b28d0a80ef@",
              "title" => "<span class=\"os-number\">3.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">What Is Culture?</span>",
              "slug" => "3-1-what-is-culture"
            },
            {
              "id" => "f298104a-d0dd-432f-83ec-3881813a7eaa@",
              "title" => "<span class=\"os-number\">3.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Elements of Culture</span>",
              "slug" => "3-2-elements-of-culture"
            },
            {
              "id" => "4ee317f2-cc23-4075-b377-51ee4d11bb61@",
              "title" => "<span class=\"os-number\">3.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Pop Culture, Subculture, and Cultural Change</span>",
              "slug" => "3-3-pop-culture-subculture-and-cultural-change"
            },
            {
              "id" => "f2055c29-6b50-4a77-89d8-f88745ce0f18@",
              "title" => "<span class=\"os-number\">3.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theoretical Perspectives on Culture</span>",
              "slug" => "3-4-theoretical-perspectives-on-culture"
            },
            {
              "id" => "e18718ba-17ab-57bd-8adf-88d63018f4bd@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "slug" => "3-key-terms"
            },
            {
              "id" => "1d6dd331-6952-5376-8972-38220ffdb61c@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "slug" => "3-section-summary"
            },
            {
              "id" => "d39b2974-73b3-5e9b-8f2a-22877b408a81@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "slug" => "3-section-quiz"
            },
            {
              "id" => "b87ddd05-92b5-5aef-8d08-5503a02b0abd@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "slug" => "3-short-answer"
            },
            {
              "id" => "2f66caf6-a94f-528b-ab3f-04b716aa52d4@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "slug" => "3-further-research"
            },
            {
              "id" => "196480ca-f09f-55fd-ad23-e6b46fd357a7@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "slug" => "3-references"
            }
          ],
          "slug" => "3-culture"
        },
        {
          "id" => "1f473fa6-ce70-5e16-9e8e-5dea6aa68537@247752b",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>4</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Society and Social Interaction</span>",
          "contents" => [
            {
              "id" => "31eae3d7-1b57-4c24-ad0b-d08a2851b70d@",
              "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Society and Social Interaction</span>",
              "slug" => "4-introduction-to-society-and-social-interaction"
            },
            {
              "id" => "aace8da1-b83e-4a5e-bfb8-5bd44699381a@",
              "title" => "<span class=\"os-number\">4.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Types of Societies</span>",
              "slug" => "4-1-types-of-societies"
            },
            {
              "id" => "6414e0c9-1e95-4b06-af38-b11762cb667e@",
              "title" => "<span class=\"os-number\">4.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theoretical Perspectives on Society</span>",
              "slug" => "4-2-theoretical-perspectives-on-society"
            },
            {
              "id" => "d06ad985-cecb-48b4-b222-197d04abc6a1@",
              "title" => "<span class=\"os-number\">4.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Social Constructions of Reality</span>",
              "slug" => "4-3-social-constructions-of-reality"
            },
            {
              "id" => "f3a073c2-5789-50f8-abfb-e5214c816bbd@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "slug" => "4-key-terms"
            },
            {
              "id" => "e0f14b6d-4df2-5d69-b17a-25889f6ad2f7@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "slug" => "4-section-summary"
            },
            {
              "id" => "038c8c7b-7161-5d23-8f14-cf3b8a808c65@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "slug" => "4-section-quiz"
            },
            {
              "id" => "357b7a1c-af6e-501c-87c9-c47f48d86f66@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "slug" => "4-short-answer"
            },
            {
              "id" => "aa893fc1-d064-5e30-9c7b-9296106faf21@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "slug" => "4-further-research"
            },
            {
              "id" => "a38bc07c-fa38-5796-9277-62f01d15925b@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "slug" => "4-references"
            }
          ],
          "slug" => "4-society-and-social-interaction"
        },
        {
          "id" => "c0ed45f6-7080-5331-882f-ca178047d6ac@247752b",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>5</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Socialization</span>",
          "contents" => [
            {
              "id" => "52eff48e-e18d-4231-9fe3-eb7ffb9ee365@",
              "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Socialization</span>",
              "slug" => "5-introduction-to-socialization"
            },
            {
              "id" => "08e4a1f1-738c-4296-b07d-e13fa2973681@",
              "title" => "<span class=\"os-number\">5.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theories of Self-Development</span>",
              "slug" => "5-1-theories-of-self-development"
            },
            {
              "id" => "cde4e88d-3f69-4711-86d9-4f3b9697383b@",
              "title" => "<span class=\"os-number\">5.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Why Socialization Matters</span>",
              "slug" => "5-2-why-socialization-matters"
            },
            {
              "id" => "3256e44f-a765-4c3a-8728-3a6c92b49a65@",
              "title" => "<span class=\"os-number\">5.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Agents of Socialization</span>",
              "slug" => "5-3-agents-of-socialization"
            },
            {
              "id" => "269040ea-022f-40d1-b2f7-4b9219fa096d@",
              "title" => "<span class=\"os-number\">5.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Socialization Across the Life Course</span>",
              "slug" => "5-4-socialization-across-the-life-course"
            },
            {
              "id" => "07d1d306-3853-5c9d-b6d4-7ccfe3ee7a3d@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "slug" => "5-key-terms"
            },
            {
              "id" => "d5d336d4-ebb9-5d70-a910-cdbbc7400cf7@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "slug" => "5-section-summary"
            },
            {
              "id" => "6b6d5e1c-0c63-52cf-a7bc-e79c2f94dfb1@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "slug" => "5-section-quiz"
            },
            {
              "id" => "32af6c6d-5b12-5218-a5e9-8bf8eb883b06@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "slug" => "5-short-answer"
            },
            {
              "id" => "dcbec3a2-5246-5ea7-b99a-076f0ae94045@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "slug" => "5-further-research"
            },
            {
              "id" => "24cb4487-b5c5-5afc-8296-fb7de89cc39c@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "slug" => "5-references"
            }
          ],
          "slug" => "5-socialization"
        },
        {
          "id" => "291effe4-4e21-5933-85de-14f430f516ae@247752b",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>6</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Groups and Organization</span>",
          "contents" => [
            {
              "id" => "74c17c8b-542d-4b6d-81b8-1188530fd1c3@",
              "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Groups and Organizations</span>",
              "slug" => "6-introduction-to-groups-and-organizations"
            },
            {
              "id" => "d95043f3-b879-4ad1-bd2c-7654f592c853@",
              "title" => "<span class=\"os-number\">6.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Types of Groups</span>",
              "slug" => "6-1-types-of-groups"
            },
            {
              "id" => "a2b20cc9-c475-4b89-bf51-03ed75861dca@",
              "title" => "<span class=\"os-number\">6.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Group Size and Structure</span>",
              "slug" => "6-2-group-size-and-structure"
            },
            {
              "id" => "aebb5e2c-a825-4192-a8c0-91678b449ec2@",
              "title" => "<span class=\"os-number\">6.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Formal Organizations</span>",
              "slug" => "6-3-formal-organizations"
            },
            {
              "id" => "895c4144-c266-5859-90fc-e72118450c58@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "slug" => "6-key-terms"
            },
            {
              "id" => "559f7e2c-6dbb-57d2-b070-c2b2ff0329b5@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "slug" => "6-section-summary"
            },
            {
              "id" => "ddad5b74-659b-5027-9e9a-61a10a3e7c12@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "slug" => "6-section-quiz"
            },
            {
              "id" => "bd671f7f-19b9-5632-9e88-54b670385e46@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "slug" => "6-short-answer"
            },
            {
              "id" => "7621e1be-0583-558d-8222-f2a5924f50b5@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "slug" => "6-further-research"
            },
            {
              "id" => "96a98d9e-8afe-5029-a453-e7265f835255@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "slug" => "6-references"
            }
          ],
          "slug" => "6-groups-and-organization"
        },
        {
          "id" => "5e82ce2f-19cb-55a3-9134-fa37757c8ef9@247752b",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>7</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Deviance, Crime, and Social Control</span>",
          "contents" => [
            {
              "id" => "178fcbde-9ec6-46de-812f-1a44ad5144a5@",
              "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Deviance, Crime, and Social Control</span>",
              "slug" => "7-introduction-to-deviance-crime-and-social-control"
            },
            {
              "id" => "cef21f33-7a41-49c6-b129-1a4e20b2b64d@",
              "title" => "<span class=\"os-number\">7.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Deviance and Control</span>",
              "slug" => "7-1-deviance-and-control"
            },
            {
              "id" => "398ece58-90b3-4378-b774-f71e06bab8fe@",
              "title" => "<span class=\"os-number\">7.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theoretical Perspectives on Deviance</span>",
              "slug" => "7-2-theoretical-perspectives-on-deviance"
            },
            {
              "id" => "dbfef635-98d1-49e6-ad56-efa7b91f506f@",
              "title" => "<span class=\"os-number\">7.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Crime and the Law</span>",
              "slug" => "7-3-crime-and-the-law"
            },
            {
              "id" => "755fdfbf-5477-51bc-93ee-48b980aa0ff6@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "slug" => "7-key-terms"
            },
            {
              "id" => "1dc48300-8875-5395-b80b-f205a684a496@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "slug" => "7-section-summary"
            },
            {
              "id" => "caaf7ecf-64ba-5f93-ba9a-ff517eff8d60@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "slug" => "7-section-quiz"
            },
            {
              "id" => "10c7e5fd-ac08-56be-ad6a-26c0f28f5e9e@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "slug" => "7-short-answer"
            },
            {
              "id" => "595a4bb3-1f83-5077-b51e-b9f05283476d@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "slug" => "7-further-research"
            },
            {
              "id" => "24cb04bf-fbcb-57c0-be0a-3c920af8a3e3@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "slug" => "7-references"
            }
          ],
          "slug" => "7-deviance-crime-and-social-control"
        },
        {
          "id" => "9682b572-5a72-57ee-8740-28a9865c66a1@247752b",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>8</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Media and Technology</span>",
          "contents" => [
            {
              "id" => "022f74e4-8ebc-4232-b3f1-e052ee6ef711@",
              "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Media and Technology</span>",
              "slug" => "8-introduction-to-media-and-technology"
            },
            {
              "id" => "ff98c048-3f87-453f-a5f9-fd962553166d@",
              "title" => "<span class=\"os-number\">8.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Technology Today</span>",
              "slug" => "8-1-technology-today"
            },
            {
              "id" => "fd4e4037-aa50-4849-8c69-0d7b80d3ef3c@",
              "title" => "<span class=\"os-number\">8.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Media and Technology in Society</span>",
              "slug" => "8-2-media-and-technology-in-society"
            },
            {
              "id" => "f8e4d21a-488f-491c-9e07-968a0b3e48ba@",
              "title" => "<span class=\"os-number\">8.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Global Implications of Media and Technology</span>",
              "slug" => "8-3-global-implications-of-media-and-technology"
            },
            {
              "id" => "62b3caf7-b83a-4ff1-bb52-953afc1a9b6d@",
              "title" => "<span class=\"os-number\">8.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theoretical Perspectives on Media and Technology</span>",
              "slug" => "8-4-theoretical-perspectives-on-media-and-technology"
            },
            {
              "id" => "6551d9c2-0c2f-572e-8c68-8f2ec1b59de0@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "slug" => "8-key-terms"
            },
            {
              "id" => "ab275695-ee4d-56b0-86d3-a32f84e00d10@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "slug" => "8-section-summary"
            },
            {
              "id" => "fd1031b4-bdb6-5ad5-a685-987022ef64b5@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "slug" => "8-section-quiz"
            },
            {
              "id" => "0c59a8d5-8fe1-531f-9d07-1fb717097b5d@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "slug" => "8-short-answer"
            },
            {
              "id" => "83f59f29-67c8-53dd-bf85-6b63bad1c501@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "slug" => "8-further-research"
            },
            {
              "id" => "3a5335cb-a85c-5760-835e-3f10c211b46c@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "slug" => "8-references"
            }
          ],
          "slug" => "8-media-and-technology"
        },
        {
          "id" => "d20d1523-5aca-5d38-93c4-a5f5cff975c7@247752b",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>9</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Social Stratification in the United States</span>",
          "contents" => [
            {
              "id" => "6e2fe486-093d-4e60-9ca3-1bbce5481b9c@",
              "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Social Stratification in the United States</span>",
              "slug" => "9-introduction-to-social-stratification-in-the-united-states"
            },
            {
              "id" => "2d80e77e-9e52-4bed-bf58-312c1b662922@",
              "title" => "<span class=\"os-number\">9.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">What Is Social Stratification?</span>",
              "slug" => "9-1-what-is-social-stratification"
            },
            {
              "id" => "61a9f276-1bde-4cef-ba2d-040bae4f90a2@",
              "title" => "<span class=\"os-number\">9.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Social Stratification and Mobility in the United States</span>",
              "slug" => "9-2-social-stratification-and-mobility-in-the-united-states"
            },
            {
              "id" => "3f1c42b1-6494-47b1-9120-fa45b47f50b7@",
              "title" => "<span class=\"os-number\">9.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Global Stratification and Inequality</span>",
              "slug" => "9-3-global-stratification-and-inequality"
            },
            {
              "id" => "34faad00-f5b5-4d54-93ae-708adc6df1ca@",
              "title" => "<span class=\"os-number\">9.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theoretical Perspectives on Social Stratification</span>",
              "slug" => "9-4-theoretical-perspectives-on-social-stratification"
            },
            {
              "id" => "17d10f13-acbf-5da2-8b7d-92aa6469bb6a@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "slug" => "9-key-terms"
            },
            {
              "id" => "44d8e9ae-6dda-5645-a222-061e91359b4a@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "slug" => "9-section-summary"
            },
            {
              "id" => "475665ab-3866-533d-8da6-2ef0473239e1@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "slug" => "9-section-quiz"
            },
            {
              "id" => "27f08dce-17be-5161-af7a-cf10eb895c1e@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "slug" => "9-short-answer"
            },
            {
              "id" => "c53a68fd-ba3d-5995-b008-7241e365e793@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "slug" => "9-further-research"
            },
            {
              "id" => "c0c7d447-82d7-5335-905b-a33a87277496@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "slug" => "9-references"
            }
          ],
          "slug" => "9-social-stratification-in-the-united-states"
        },
        {
          "id" => "ab68f635-6c5a-56d6-9253-d3a2d93e9e72@247752b",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>10</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Global Inequality</span>",
          "contents" => [
            {
              "id" => "b6166e6a-8ffe-494c-a1f3-7e4acb668280@",
              "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Global Inequality</span>",
              "slug" => "10-introduction-to-global-inequality"
            },
            {
              "id" => "ed308f6a-61dd-447b-b1b4-5118e7e25b22@",
              "title" => "<span class=\"os-number\">10.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Global Stratification and Classification</span>",
              "slug" => "10-1-global-stratification-and-classification"
            },
            {
              "id" => "d7c18fbb-e549-46da-aff4-68e60949d130@",
              "title" => "<span class=\"os-number\">10.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Global Wealth and Poverty</span>",
              "slug" => "10-2-global-wealth-and-poverty"
            },
            {
              "id" => "c9770cc1-8415-475d-b691-99b289598974@",
              "title" => "<span class=\"os-number\">10.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theoretical Perspectives on Global Stratification</span>",
              "slug" => "10-3-theoretical-perspectives-on-global-stratification"
            },
            {
              "id" => "4c4d8bbb-1444-57cf-ad74-babe95fb414d@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "slug" => "10-key-terms"
            },
            {
              "id" => "17aa110c-a483-53d5-a65c-1c7a56aa28a8@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "slug" => "10-section-summary"
            },
            {
              "id" => "927bd6e7-917c-5b94-b239-100d57909e99@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "slug" => "10-section-quiz"
            },
            {
              "id" => "6ec0e754-cace-587e-8288-32587285a1be@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "slug" => "10-short-answer"
            },
            {
              "id" => "8f759c99-2e79-59e4-b199-dce83572ee35@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "slug" => "10-further-research"
            },
            {
              "id" => "a05f3d1e-e473-5ead-9b3b-3b4bf7fee919@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "slug" => "10-references"
            }
          ],
          "slug" => "10-global-inequality"
        },
        {
          "id" => "05279e72-a6ae-538b-be85-1bc1cd6577e0@247752b",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>11</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Race and Ethnicity</span>",
          "contents" => [
            {
              "id" => "1f4db786-0c13-415a-a456-ab07a24b2dfb@",
              "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Race and Ethnicity</span>",
              "slug" => "11-introduction-to-race-and-ethnicity"
            },
            {
              "id" => "a55ca711-352c-47cb-ba17-35b00eb1f18a@",
              "title" => "<span class=\"os-number\">11.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Racial, Ethnic, and Minority Groups</span>",
              "slug" => "11-1-racial-ethnic-and-minority-groups"
            },
            {
              "id" => "d310a908-eb93-4b62-881a-12864fbb7157@",
              "title" => "<span class=\"os-number\">11.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Stereotypes, Prejudice, and Discrimination</span>",
              "slug" => "11-2-stereotypes-prejudice-and-discrimination"
            },
            {
              "id" => "b1afff9f-c485-4245-8ca2-30de4666d03b@",
              "title" => "<span class=\"os-number\">11.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theories of Race and Ethnicity</span>",
              "slug" => "11-3-theories-of-race-and-ethnicity"
            },
            {
              "id" => "134db5ed-6e53-42da-b821-6347b7b2554d@",
              "title" => "<span class=\"os-number\">11.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Intergroup Relationships</span>",
              "slug" => "11-4-intergroup-relationships"
            },
            {
              "id" => "b3cb90e7-b5d7-4e9c-91fc-e4fa2887f971@",
              "title" => "<span class=\"os-number\">11.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Race and Ethnicity in the United States</span>",
              "slug" => "11-5-race-and-ethnicity-in-the-united-states"
            },
            {
              "id" => "fe09c141-01dd-5590-9188-69ef5a5e17a5@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "slug" => "11-key-terms"
            },
            {
              "id" => "c29e75a0-a50d-58eb-be4f-5488b0cc9c1f@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "slug" => "11-section-summary"
            },
            {
              "id" => "652bb24f-73ef-5e07-9f08-ede1abd98fde@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "slug" => "11-section-quiz"
            },
            {
              "id" => "57468a5b-6a7c-5d2c-a5ef-1d28dbe3d603@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "slug" => "11-short-answer"
            },
            {
              "id" => "9b0eaf7f-6cce-597d-8af9-419c6b08ad02@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "slug" => "11-further-research"
            },
            {
              "id" => "a26e7402-1fbb-5dd7-bb56-ce27a090f187@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "slug" => "11-references"
            }
          ],
          "slug" => "11-race-and-ethnicity"
        },
        {
          "id" => "38cac246-2881-5863-8ed3-24ece737993e@247752b",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>12</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Gender, Sex, and Sexuality</span>",
          "contents" => [
            {
              "id" => "4fff8b4d-65dd-4c21-9dc2-d33bfc9ae1c0@",
              "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Gender, Sex, and Sexuality</span>",
              "slug" => "12-introduction-to-gender-sex-and-sexuality"
            },
            {
              "id" => "26f66ec2-2527-441d-97a2-5e2d170cfc57@",
              "title" => "<span class=\"os-number\">12.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Sex and Gender</span>",
              "slug" => "12-1-sex-and-gender"
            },
            {
              "id" => "2138442f-2ad7-4ec3-9972-fc913805b42a@",
              "title" => "<span class=\"os-number\">12.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Gender</span>",
              "slug" => "12-2-gender"
            },
            {
              "id" => "672dd126-9ce3-4175-9db3-5bff44be91fe@",
              "title" => "<span class=\"os-number\">12.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Sex and Sexuality</span>",
              "slug" => "12-3-sex-and-sexuality"
            },
            {
              "id" => "d34f3e2f-e282-5faa-a4be-63a2b306dba0@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "slug" => "12-key-terms"
            },
            {
              "id" => "d96d8526-4525-5b3e-946a-39b91009daf6@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "slug" => "12-section-summary"
            },
            {
              "id" => "eae055b5-6e99-5ac3-a5c2-ad0d4872a68f@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "slug" => "12-section-quiz"
            },
            {
              "id" => "5d83af92-2759-528f-90c4-e7ccfd9b2df7@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "slug" => "12-short-answer"
            },
            {
              "id" => "2187aff8-22e6-5b9a-9853-0a4e6d1184c9@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "slug" => "12-further-research"
            },
            {
              "id" => "f7104d28-024c-5890-af2a-308f84aac6f9@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "slug" => "12-references"
            }
          ],
          "slug" => "12-gender-sex-and-sexuality"
        },
        {
          "id" => "d9be7457-30a3-5811-ac28-c5af83f9f32f@247752b",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>13</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Aging and the Elderly</span>",
          "contents" => [
            {
              "id" => "acdddf86-67ea-453a-861f-efb0a4b50202@",
              "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Aging and the Elderly</span>",
              "slug" => "13-introduction-to-aging-and-the-elderly"
            },
            {
              "id" => "f4ce6106-f567-43a2-bcd9-f29ac6d7ea7c@",
              "title" => "<span class=\"os-number\">13.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Who Are the Elderly? Aging in Society</span>",
              "slug" => "13-1-who-are-the-elderly-aging-in-society"
            },
            {
              "id" => "d9df5e48-4b72-482e-b616-886926188054@",
              "title" => "<span class=\"os-number\">13.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Process of Aging</span>",
              "slug" => "13-2-the-process-of-aging"
            },
            {
              "id" => "a1ccdea8-6ff8-40ea-adc4-38bab44d04ee@",
              "title" => "<span class=\"os-number\">13.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Challenges Facing the Elderly</span>",
              "slug" => "13-3-challenges-facing-the-elderly"
            },
            {
              "id" => "ade7fd74-8340-4c21-a537-7d4c8d67d965@",
              "title" => "<span class=\"os-number\">13.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theoretical Perspectives on Aging</span>",
              "slug" => "13-4-theoretical-perspectives-on-aging"
            },
            {
              "id" => "76e10f79-f412-59b1-bbb7-599cf2c5d6ea@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "slug" => "13-key-terms"
            },
            {
              "id" => "80faa867-d749-570f-993d-b5c7881f659d@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "slug" => "13-section-summary"
            },
            {
              "id" => "8af16f1e-4a33-5dfa-8e7d-d43735eafdb7@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "slug" => "13-section-quiz"
            },
            {
              "id" => "4c3c8a4f-b5de-590b-b556-cfe6dbb53698@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "slug" => "13-short-answer"
            },
            {
              "id" => "3968d24e-3260-52b3-bbed-ad6293cca527@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "slug" => "13-further-research"
            },
            {
              "id" => "041738c8-d345-5e40-a352-0f08c9943a7b@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "slug" => "13-references"
            }
          ],
          "slug" => "13-aging-and-the-elderly"
        },
        {
          "id" => "021eb180-bb49-50f9-976a-02e8e36f9f35@247752b",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>14</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Marriage and Family</span>",
          "contents" => [
            {
              "id" => "f05f32bf-ca44-4bcf-80c1-9377fb1d21f7@",
              "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Marriage and Family</span>",
              "slug" => "14-introduction-to-marriage-and-family"
            },
            {
              "id" => "fc2d2208-0a60-425e-9217-0d6ee659be7e@",
              "title" => "<span class=\"os-number\">14.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">What Is Marriage? What Is a Family?</span>",
              "slug" => "14-1-what-is-marriage-what-is-a-family"
            },
            {
              "id" => "fc504354-e135-4a28-b22a-2054dea6e315@",
              "title" => "<span class=\"os-number\">14.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Variations in Family Life</span>",
              "slug" => "14-2-variations-in-family-life"
            },
            {
              "id" => "5f441b6a-ae68-4d84-a106-1d1b011f0331@",
              "title" => "<span class=\"os-number\">14.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Challenges Families Face</span>",
              "slug" => "14-3-challenges-families-face"
            },
            {
              "id" => "5357eb1a-295e-535d-b7a7-4480557272e3@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "slug" => "14-key-terms"
            },
            {
              "id" => "0576761e-98b8-547b-93b8-ef1aa119c3f0@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "slug" => "14-section-summary"
            },
            {
              "id" => "c50a2095-d61d-53f4-bad7-8209f1322bf1@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "slug" => "14-section-quiz"
            },
            {
              "id" => "bfee28a0-f52a-565c-91c9-a0bb17130c7d@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "slug" => "14-short-answer"
            },
            {
              "id" => "4d2104b1-81c7-5a2a-907f-590eaf48c4cf@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "slug" => "14-further-research"
            },
            {
              "id" => "829a290f-de59-5b7e-9d78-ca20353fb33b@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "slug" => "14-references"
            }
          ],
          "slug" => "14-marriage-and-family"
        },
        {
          "id" => "7c429978-bf11-51d0-907a-a4477d9bf3db@247752b",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>15</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Religion</span>",
          "contents" => [
            {
              "id" => "a7255255-e4f0-472c-81c0-54ab97cb2e68@",
              "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Religion</span>",
              "slug" => "15-introduction-to-religion"
            },
            {
              "id" => "53d3be59-277f-4139-b821-d04960c33d0b@",
              "title" => "<span class=\"os-number\">15.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Sociological Approach to Religion</span>",
              "slug" => "15-1-the-sociological-approach-to-religion"
            },
            {
              "id" => "93ebe6b3-6e50-4dc1-9bc0-a55f6935bccb@",
              "title" => "<span class=\"os-number\">15.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">World Religions</span>",
              "slug" => "15-2-world-religions"
            },
            {
              "id" => "5def2064-5c90-44ae-a963-6ecff5b80975@",
              "title" => "<span class=\"os-number\">15.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Religion in the United States</span>",
              "slug" => "15-3-religion-in-the-united-states"
            },
            {
              "id" => "fc0df951-64ba-5c34-9e8e-fea5d1f18a95@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "slug" => "15-key-terms"
            },
            {
              "id" => "2fd07a19-bdf8-5896-9edd-a53ae70eeebc@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "slug" => "15-section-summary"
            },
            {
              "id" => "5d03ae96-42d3-5f27-b5fc-5d410b33f042@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "slug" => "15-section-quiz"
            },
            {
              "id" => "16c7c794-e94f-594a-90ab-90d181e6a74d@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "slug" => "15-short-answer"
            },
            {
              "id" => "8a45358a-8782-5283-bf97-0648fa051ab3@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "slug" => "15-further-research"
            },
            {
              "id" => "a6d4f5bb-2647-596b-ae15-29fb3f95e55e@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "slug" => "15-references"
            }
          ],
          "slug" => "15-religion"
        },
        {
          "id" => "760fb7ef-98ac-5f22-934f-cbd52d96e799@247752b",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>16</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Education</span>",
          "contents" => [
            {
              "id" => "443cd6b3-64bc-4803-bd6a-eb216790a130@",
              "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Education</span>",
              "slug" => "16-introduction-to-education"
            },
            {
              "id" => "55daa5bc-71b0-4578-8fec-51e39b581abd@",
              "title" => "<span class=\"os-number\">16.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Education around the World</span>",
              "slug" => "16-1-education-around-the-world"
            },
            {
              "id" => "43b4a12e-66b6-479a-935d-f5e568a10463@",
              "title" => "<span class=\"os-number\">16.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theoretical Perspectives on Education</span>",
              "slug" => "16-2-theoretical-perspectives-on-education"
            },
            {
              "id" => "984be05e-c3eb-422d-9170-47b1f0d02c9c@",
              "title" => "<span class=\"os-number\">16.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Issues in Education</span>",
              "slug" => "16-3-issues-in-education"
            },
            {
              "id" => "274c4c62-bba8-538d-8430-544f3384e585@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "slug" => "16-key-terms"
            },
            {
              "id" => "63d49d09-a0ce-5dca-8241-6bbc6f43fb05@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "slug" => "16-section-summary"
            },
            {
              "id" => "50c15692-1e97-506f-8ee0-0531c41873f4@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "slug" => "16-section-quiz"
            },
            {
              "id" => "dfd829bf-f7a4-5e98-8026-5c74636cb95c@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "slug" => "16-short-answer"
            },
            {
              "id" => "2cf3f92d-299a-51a3-b8f3-39ef0cf2b380@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "slug" => "16-further-research"
            },
            {
              "id" => "9f082306-fe4b-59bf-b747-abf39b3783d3@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "slug" => "16-references"
            }
          ],
          "slug" => "16-education"
        },
        {
          "id" => "fd3ea0f6-1992-52e7-bc51-f239002a5429@247752b",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>17</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Government and Politics</span>",
          "contents" => [
            {
              "id" => "75703577-ab2a-4b1d-860f-94514729c298@",
              "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Government and Politics</span>",
              "slug" => "17-introduction-to-government-and-politics"
            },
            {
              "id" => "1af78294-fbeb-49fe-b2cf-fd747f5a3e2e@",
              "title" => "<span class=\"os-number\">17.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Power and Authority</span>",
              "slug" => "17-1-power-and-authority"
            },
            {
              "id" => "bf6698dd-c4d7-4559-82b2-3915859e3d75@",
              "title" => "<span class=\"os-number\">17.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Forms of Government</span>",
              "slug" => "17-2-forms-of-government"
            },
            {
              "id" => "1c4bead3-4898-4fe9-b5f9-fb91e8a00c3a@",
              "title" => "<span class=\"os-number\">17.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Politics in the United States</span>",
              "slug" => "17-3-politics-in-the-united-states"
            },
            {
              "id" => "940de604-e01b-4565-81df-78985b79919a@",
              "title" => "<span class=\"os-number\">17.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theoretical Perspectives on Government and Power</span>",
              "slug" => "17-4-theoretical-perspectives-on-government-and-power"
            },
            {
              "id" => "5675bf85-db89-5491-930a-d74314e236d6@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "slug" => "17-key-terms"
            },
            {
              "id" => "1ba33a0d-26cd-511e-a017-3bd91f13a2cd@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "slug" => "17-section-summary"
            },
            {
              "id" => "2e8e15a5-3349-5135-b51f-8f7e594d0590@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "slug" => "17-section-quiz"
            },
            {
              "id" => "ce3f1ab2-861a-5032-9aca-efed828c69c1@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "slug" => "17-short-answer"
            },
            {
              "id" => "85809e34-cda8-556a-be26-0bf61a352927@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "slug" => "17-further-research"
            },
            {
              "id" => "d2cda32c-5912-5ae2-9ae1-e33464393095@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "slug" => "17-references"
            }
          ],
          "slug" => "17-government-and-politics"
        },
        {
          "id" => "6a0430fe-03d6-5ff8-89bb-ac7ae445f2ac@247752b",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>18</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Work and the Economy</span>",
          "contents" => [
            {
              "id" => "6bde5892-e610-4f5f-bfbb-84f624ace8c6@",
              "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Work and the Economy</span>",
              "slug" => "18-introduction-to-work-and-the-economy"
            },
            {
              "id" => "36f9cf93-9c5d-41f1-8c14-d7c89fea9b85@",
              "title" => "<span class=\"os-number\">18.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Economic Systems</span>",
              "slug" => "18-1-economic-systems"
            },
            {
              "id" => "5fe19034-9a53-44c7-bdc5-346d0d0753dc@",
              "title" => "<span class=\"os-number\">18.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Globalization and the Economy</span>",
              "slug" => "18-2-globalization-and-the-economy"
            },
            {
              "id" => "71d09a20-73f5-4265-9bae-7c5bc70a0a47@",
              "title" => "<span class=\"os-number\">18.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Work in the United States</span>",
              "slug" => "18-3-work-in-the-united-states"
            },
            {
              "id" => "cd538d9e-7dd9-5766-97ac-0d77e5dd6b06@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "slug" => "18-key-terms"
            },
            {
              "id" => "76636eed-80a1-5ad6-acc4-0282db887f1a@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "slug" => "18-section-summary"
            },
            {
              "id" => "8e7c57da-459b-523b-9257-6341e874c217@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "slug" => "18-section-quiz"
            },
            {
              "id" => "f14b1e01-a3b0-59ce-81ee-9e623af69d21@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "slug" => "18-short-answer"
            },
            {
              "id" => "f6f63364-a74d-5d57-96e5-66e6f7ebdaae@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "slug" => "18-further-research"
            },
            {
              "id" => "5ea90537-033f-51e7-8f4a-d81a97039d8c@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "slug" => "18-references"
            }
          ],
          "slug" => "18-work-and-the-economy"
        },
        {
          "id" => "9bc013c6-85d5-5483-8888-763df92d1b26@247752b",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>19</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Health and Medicine</span>",
          "contents" => [
            {
              "id" => "5f90d10f-2f6a-486c-86d4-893653b26b83@",
              "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Health and Medicine</span>",
              "slug" => "19-introduction-to-health-and-medicine"
            },
            {
              "id" => "e31c5006-5e21-43fc-b070-c5347066cd96@",
              "title" => "<span class=\"os-number\">19.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Social Construction of Health</span>",
              "slug" => "19-1-the-social-construction-of-health"
            },
            {
              "id" => "d1ef539d-3612-4154-b787-6835fe93703b@",
              "title" => "<span class=\"os-number\">19.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Global Health</span>",
              "slug" => "19-2-global-health"
            },
            {
              "id" => "f3a2b187-e44d-4a5f-af59-ee4bcd39046f@",
              "title" => "<span class=\"os-number\">19.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Health in the United States</span>",
              "slug" => "19-3-health-in-the-united-states"
            },
            {
              "id" => "86d65916-f669-4a65-9187-15d83e2d1689@",
              "title" => "<span class=\"os-number\">19.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Comparative Health and Medicine</span>",
              "slug" => "19-4-comparative-health-and-medicine"
            },
            {
              "id" => "54923470-ad35-40ef-b09c-da89b0e19da5@",
              "title" => "<span class=\"os-number\">19.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theoretical Perspectives on Health and Medicine</span>",
              "slug" => "19-5-theoretical-perspectives-on-health-and-medicine"
            },
            {
              "id" => "d88185c1-db86-5389-975a-77f5d1e2c4d9@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "slug" => "19-key-terms"
            },
            {
              "id" => "e5d863ee-74f9-5975-90f8-4636b87dbf1b@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "slug" => "19-section-summary"
            },
            {
              "id" => "981cfc29-bbb3-5e96-96e6-ca5c7174e678@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "slug" => "19-section-quiz"
            },
            {
              "id" => "03b7607c-ee84-5ff1-bca2-de3b05df710c@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "slug" => "19-short-answer"
            },
            {
              "id" => "ec196185-0f4b-538d-8dea-ab888976e35e@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "slug" => "19-further-research"
            },
            {
              "id" => "52707f50-92d9-54c7-a635-63b37829f17c@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "slug" => "19-references"
            }
          ],
          "slug" => "19-health-and-medicine"
        },
        {
          "id" => "21a970b1-6434-508d-bb9c-0aceab73a87a@247752b",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>20</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Population, Urbanization, and the Environment</span>",
          "contents" => [
            {
              "id" => "8803c7d4-c848-4b4e-a743-82f7477eb764@",
              "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Population, Urbanization, and the Environment</span>",
              "slug" => "20-introduction-to-population-urbanization-and-the-environment"
            },
            {
              "id" => "2cf134f9-f88e-4590-8c33-404ead13ab83@",
              "title" => "<span class=\"os-number\">20.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Demography and Population</span>",
              "slug" => "20-1-demography-and-population"
            },
            {
              "id" => "4c117289-4d19-4892-82dd-c0e820ea9041@",
              "title" => "<span class=\"os-number\">20.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Urbanization</span>",
              "slug" => "20-2-urbanization"
            },
            {
              "id" => "a9c17e87-c269-4cd2-b540-aaf6cc273dbf@",
              "title" => "<span class=\"os-number\">20.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Environment and Society</span>",
              "slug" => "20-3-the-environment-and-society"
            },
            {
              "id" => "62697181-64c2-54a4-a557-9b7bd96f461c@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "slug" => "20-key-terms"
            },
            {
              "id" => "7788b646-eccc-5e37-82ea-936eb32d87e4@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "slug" => "20-section-summary"
            },
            {
              "id" => "0123e588-6856-558c-bf33-e6697299568c@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "slug" => "20-section-quiz"
            },
            {
              "id" => "253e7ab7-491c-5ce1-ab8a-ea36a97a74c2@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "slug" => "20-short-answer"
            },
            {
              "id" => "b5efbc22-ba7f-5de3-a167-acca92e01ac1@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "slug" => "20-further-research"
            },
            {
              "id" => "73d65c29-d568-58bd-89e0-03117acdb9b2@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "slug" => "20-references"
            }
          ],
          "slug" => "20-population-urbanization-and-the-environment"
        },
        {
          "id" => "6c1c6896-f686-52b5-aa95-43c9b662166b@247752b",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>21</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Social Movements and Social Change</span>",
          "contents" => [
            {
              "id" => "31d1b1ea-ca56-4379-af73-b08eef4165ab@",
              "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Social Movements and Social Change</span>",
              "slug" => "21-introduction-to-social-movements-and-social-change"
            },
            {
              "id" => "21126f9c-6b12-4860-a396-01a3ba24393e@",
              "title" => "<span class=\"os-number\">21.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Collective Behavior</span>",
              "slug" => "21-1-collective-behavior"
            },
            {
              "id" => "cea139cd-98de-4841-91e6-abcb0baa92da@",
              "title" => "<span class=\"os-number\">21.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Social Movements</span>",
              "slug" => "21-2-social-movements"
            },
            {
              "id" => "be2e1e07-67a1-469b-b17c-109fda35d510@",
              "title" => "<span class=\"os-number\">21.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Social Change</span>",
              "slug" => "21-3-social-change"
            },
            {
              "id" => "816c3585-f399-5dd4-b14c-fd6d2b32b7e0@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "slug" => "21-key-terms"
            },
            {
              "id" => "2e22c33f-e4fd-592f-bca4-c6396e64c42c@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "slug" => "21-section-summary"
            },
            {
              "id" => "977ba877-734c-599f-84cf-83d345f0ed27@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "slug" => "21-section-quiz"
            },
            {
              "id" => "fa660f0f-bd7c-596e-a16a-af7a847bbd34@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "slug" => "21-short-answer"
            },
            {
              "id" => "db5b4f91-0614-5937-a7af-a63c79980444@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "slug" => "21-references"
            }
          ],
          "slug" => "21-social-movements-and-social-change"
        },
        {
          "id" => "ee970b62-d1a3-526c-8c4e-cb04346efdbb@247752b",
          "title" => "<span class=\"os-text\">Index</span>",
          "slug" => "index"
        }
      ]
    end

    it 'searches previous archive versions when the latest book version is not found' do
      api_get api_book_url(uuid: '185cbf87-c72e-48f5-b51e-f14f21b5eabd'), user_token
      expect(response).to have_http_status(:ok)

      expect(JSON.parse body).to eq [
        {
          "id" => "7d501ff3-7b18-4b9e-99fd-2f596024f3a1@",
          "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Preface</span>",
          "slug" => "preface"
        },
        {
          "id" => "b642a710-1f2f-5780-9413-5a6bcd0ad3c1@e989ec3",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Unit </span>1</span>\n    <span class=\"os-divider\"> </span>\n    <span data-type=\"\" itemprop=\"\" class=\"os-text\">Unit 1. The Chemistry of Life</span>",
          "contents" => [
            {
              "id" => "0e4799ec-e0f3-5e41-8e80-0a69b7fc550a@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>1</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">The Study of Life</span>",
              "contents" => [
                {
                  "id" => "ad9b9d37-a5cf-4a0d-b8c1-083fcc4d3b0c@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "1-introduction"
                },
                {
                  "id" => "6a0568d8-23d7-439b-9a01-16e4e73886b3@",
                  "title" => "<span class=\"os-number\">1.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Science of Biology</span>",
                  "slug" => "1-1-the-science-of-biology"
                },
                {
                  "id" => "80d2e9ef-abee-40c2-8586-5459a67c81f3@",
                  "title" => "<span class=\"os-number\">1.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Themes and Concepts of Biology</span>",
                  "slug" => "1-2-themes-and-concepts-of-biology"
                },
                {
                  "id" => "0b26e8c9-1784-5aa1-bce1-1beb7ddd997d@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "1-key-terms"
                },
                {
                  "id" => "fdaa8ea9-7591-58fd-950c-10932ccc1cb9@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "1-chapter-summary"
                },
                {
                  "id" => "f889057f-e071-5076-a55e-c743ac53ab15@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "1-visual-connection-questions"
                },
                {
                  "id" => "966ddb5b-86e6-57aa-8fb6-e1fb8970de68@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "1-review-questions"
                },
                {
                  "id" => "731d103c-ebd7-58e7-8df4-b58cd62ae5f6@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "1-critical-thinking-questions"
                }
              ],
              "slug" => "1-the-study-of-life"
            },
            {
              "id" => "6e322e93-f9c0-50a5-8481-c2686c38f9b6@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>2</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">The Chemical Foundation of Life</span>",
              "contents" => [
                {
                  "id" => "7636a3bf-eb80-4898-8b2c-e81c1711b99f@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "2-introduction"
                },
                {
                  "id" => "be8818d0-2dba-4bf3-859a-737c25fb2c99@",
                  "title" => "<span class=\"os-number\">2.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Atoms, Isotopes, Ions, and Molecules: The Building Blocks</span>",
                  "slug" => "2-1-atoms-isotopes-ions-and-molecules-the-building-blocks"
                },
                {
                  "id" => "a4f8df82-c778-4971-8dcc-7c5c72578e94@",
                  "title" => "<span class=\"os-number\">2.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Water</span>",
                  "slug" => "2-2-water"
                },
                {
                  "id" => "52bfe5d1-7f8a-49b1-9c47-973d3f518958@",
                  "title" => "<span class=\"os-number\">2.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Carbon</span>",
                  "slug" => "2-3-carbon"
                },
                {
                  "id" => "a3e8931e-e26a-5f32-93f4-eb866d94541b@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "2-key-terms"
                },
                {
                  "id" => "f2da3ed3-67f6-5700-af42-6c4463071702@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "2-chapter-summary"
                },
                {
                  "id" => "2ce79d9d-6219-5862-98b2-a8a6d969def5@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "2-visual-connection-questions"
                },
                {
                  "id" => "12e876ba-ac3c-5d5a-a328-02e74b452a6d@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "2-review-questions"
                },
                {
                  "id" => "2dfcc310-5154-55bd-9fda-e7767c99826d@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "2-critical-thinking-questions"
                }
              ],
              "slug" => "2-the-chemical-foundation-of-life"
            },
            {
              "id" => "45856fc2-21a6-55cb-87b7-d551b412802e@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>3</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Biological Macromolecules</span>",
              "contents" => [
                {
                  "id" => "ee61d395-bee6-4692-8f3d-42159c445365@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "3-introduction"
                },
                {
                  "id" => "ea44b8fa-e7a2-4360-ad34-ac081bcf104f@",
                  "title" => "<span class=\"os-number\">3.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Synthesis of Biological Macromolecules</span>",
                  "slug" => "3-1-synthesis-of-biological-macromolecules"
                },
                {
                  "id" => "73b3ac54-811c-4bce-a9dd-e83f8c0dda77@",
                  "title" => "<span class=\"os-number\">3.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Carbohydrates</span>",
                  "slug" => "3-2-carbohydrates"
                },
                {
                  "id" => "23ff3343-6924-4c37-8a08-876db2e9e242@",
                  "title" => "<span class=\"os-number\">3.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Lipids</span>",
                  "slug" => "3-3-lipids"
                },
                {
                  "id" => "db3ce6d5-01bd-4ac5-a641-de285fdac0f1@",
                  "title" => "<span class=\"os-number\">3.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Proteins</span>",
                  "slug" => "3-4-proteins"
                },
                {
                  "id" => "cb178029-ce17-4c82-aa11-94a2acf4accf@",
                  "title" => "<span class=\"os-number\">3.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Nucleic Acids</span>",
                  "slug" => "3-5-nucleic-acids"
                },
                {
                  "id" => "7d0e5350-1538-5190-bcc9-bd8264e2687c@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "3-key-terms"
                },
                {
                  "id" => "596c9b4e-6b5f-5c70-bac9-78e94f155153@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "3-chapter-summary"
                },
                {
                  "id" => "39f2c05d-2c84-5a06-8d32-c2f9a6b88c8b@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "3-visual-connection-questions"
                },
                {
                  "id" => "e81bea89-ced6-5884-91b7-05e4efc86deb@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "3-review-questions"
                },
                {
                  "id" => "c837444f-528b-5f39-9c6c-de515995745d@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "3-critical-thinking-questions"
                }
              ],
              "slug" => "3-biological-macromolecules"
            }
          ],
          "slug" => "1-unit-1-the-chemistry-of-life"
        },
        {
          "id" => "648955bb-7303-5083-ab5a-b27ac5571787@e989ec3",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Unit </span>2</span>\n    <span class=\"os-divider\"> </span>\n    <span data-type=\"\" itemprop=\"\" class=\"os-text\">Unit 2. The Cell</span>",
          "contents" => [
            {
              "id" => "7b9e049b-0d7f-536e-9ccc-39825a3dc445@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>4</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Cell Structure</span>",
              "contents" => [
                {
                  "id" => "e98bdaec-4060-4b43-ac70-681555a30e22@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "4-introduction"
                },
                {
                  "id" => "003aedba-f354-4e57-ba45-f8b4eda66e12@",
                  "title" => "<span class=\"os-number\">4.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Studying Cells</span>",
                  "slug" => "4-1-studying-cells"
                },
                {
                  "id" => "a4ea5574-8c29-4a6d-a9af-3301ed2fdaa0@",
                  "title" => "<span class=\"os-number\">4.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Prokaryotic Cells</span>",
                  "slug" => "4-2-prokaryotic-cells"
                },
                {
                  "id" => "14f17ea6-1853-4b32-a834-576eb6dfeb67@",
                  "title" => "<span class=\"os-number\">4.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Eukaryotic Cells</span>",
                  "slug" => "4-3-eukaryotic-cells"
                },
                {
                  "id" => "10b53780-2949-45e7-961b-aafefeec467a@",
                  "title" => "<span class=\"os-number\">4.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Endomembrane System and Proteins</span>",
                  "slug" => "4-4-the-endomembrane-system-and-proteins"
                },
                {
                  "id" => "736d0748-2d71-4db3-90bd-16ef0a9ad64d@",
                  "title" => "<span class=\"os-number\">4.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Cytoskeleton</span>",
                  "slug" => "4-5-the-cytoskeleton"
                },
                {
                  "id" => "f14ca9c7-bbee-4ea2-ac54-b0a3c6d4bda7@",
                  "title" => "<span class=\"os-number\">4.6</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Connections between Cells and Cellular Activities</span>",
                  "slug" => "4-6-connections-between-cells-and-cellular-activities"
                },
                {
                  "id" => "245c74c6-5eb0-5017-a884-d1dff6ee9ecd@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "4-key-terms"
                },
                {
                  "id" => "115c0564-d8f8-51cc-9f76-53936324512f@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "4-chapter-summary"
                },
                {
                  "id" => "8946f768-f3b2-5285-bcb5-3c131394b1cd@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "4-visual-connection-questions"
                },
                {
                  "id" => "09c5c4a9-daba-53a8-ad71-c4e1e6d6e09b@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "4-review-questions"
                },
                {
                  "id" => "5a157516-f41c-588f-a5d1-63d31c2704eb@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "4-critical-thinking-questions"
                }
              ],
              "slug" => "4-cell-structure"
            },
            {
              "id" => "e4d9300b-0194-58f8-bed4-0274808ac883@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>5</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Structure and Function of Plasma Membranes</span>",
              "contents" => [
                {
                  "id" => "a1a2f03a-701f-4e7a-ae0e-d8087880c6fd@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "5-introduction"
                },
                {
                  "id" => "40e1947a-5a8b-4314-a9e7-bae3cedb885d@",
                  "title" => "<span class=\"os-number\">5.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Components and Structure</span>",
                  "slug" => "5-1-components-and-structure"
                },
                {
                  "id" => "e97f68fb-49fa-47ba-875b-6b1d59d8f11b@",
                  "title" => "<span class=\"os-number\">5.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Passive Transport</span>",
                  "slug" => "5-2-passive-transport"
                },
                {
                  "id" => "0a64c993-2b3c-4cd6-94f8-1d864df896ce@",
                  "title" => "<span class=\"os-number\">5.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Active Transport</span>",
                  "slug" => "5-3-active-transport"
                },
                {
                  "id" => "1f0bcd44-86e1-4c34-af1e-3de348baa8d4@",
                  "title" => "<span class=\"os-number\">5.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Bulk Transport</span>",
                  "slug" => "5-4-bulk-transport"
                },
                {
                  "id" => "70481832-9ad4-50bf-b595-ecca73cfe683@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "5-key-terms"
                },
                {
                  "id" => "c70ffc40-9859-5302-8aa6-4a316ec6810d@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "5-chapter-summary"
                },
                {
                  "id" => "81d38106-536d-5429-bbee-dab3ab516222@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "5-visual-connection-questions"
                },
                {
                  "id" => "e674fcc4-82c6-5dce-9c2c-0d8f52cd9a1d@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "5-review-questions"
                },
                {
                  "id" => "f4ed5931-bc8d-5a92-8cf5-da855c20eaf2@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "5-critical-thinking-questions"
                }
              ],
              "slug" => "5-structure-and-function-of-plasma-membranes"
            },
            {
              "id" => "4a941b63-19d1-5caf-8425-aaf35bf635bf@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>6</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Metabolism</span>",
              "contents" => [
                {
                  "id" => "77d140f0-5582-48ad-9119-79bdb81fbc70@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "6-introduction"
                },
                {
                  "id" => "ed5df737-77ff-452c-b91e-a2c2dad59606@",
                  "title" => "<span class=\"os-number\">6.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Energy and Metabolism</span>",
                  "slug" => "6-1-energy-and-metabolism"
                },
                {
                  "id" => "16b284a1-de63-4e08-910a-8baf1b94fc1e@",
                  "title" => "<span class=\"os-number\">6.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Potential, Kinetic, Free, and Activation Energy</span>",
                  "slug" => "6-2-potential-kinetic-free-and-activation-energy"
                },
                {
                  "id" => "1d93a84f-d3e4-498b-99fb-36f389084856@",
                  "title" => "<span class=\"os-number\">6.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Laws of Thermodynamics</span>",
                  "slug" => "6-3-the-laws-of-thermodynamics"
                },
                {
                  "id" => "99c09a74-d755-47ec-a38d-f6cc1aa5a6a7@",
                  "title" => "<span class=\"os-number\">6.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">ATP: Adenosine Triphosphate</span>",
                  "slug" => "6-4-atp-adenosine-triphosphate"
                },
                {
                  "id" => "3270ba1a-e262-481e-9902-61ef811251d5@",
                  "title" => "<span class=\"os-number\">6.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Enzymes</span>",
                  "slug" => "6-5-enzymes"
                },
                {
                  "id" => "1fac8b59-9ad4-55e2-91eb-8b734b876eae@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "6-key-terms"
                },
                {
                  "id" => "23a35e5a-cac4-5b1d-ab0e-9e814f22e302@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "6-chapter-summary"
                },
                {
                  "id" => "d4157d64-1500-50c7-8a88-a490d4485a0e@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "6-visual-connection-questions"
                },
                {
                  "id" => "a31ce2d5-0b80-52a8-ae6a-8186677c7381@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "6-review-questions"
                },
                {
                  "id" => "01f105b1-290c-51a1-8863-89c22e99a721@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "6-critical-thinking-questions"
                }
              ],
              "slug" => "6-metabolism"
            },
            {
              "id" => "ce3d410c-68e4-5f38-b5f9-ae5e3de78766@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>7</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Cellular Respiration</span>",
              "contents" => [
                {
                  "id" => "e5cf99b1-c357-48c0-bd05-e15557c89951@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "7-introduction"
                },
                {
                  "id" => "75fabe48-5fbc-458b-9062-010dd3886ae5@",
                  "title" => "<span class=\"os-number\">7.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Energy in Living Systems</span>",
                  "slug" => "7-1-energy-in-living-systems"
                },
                {
                  "id" => "b58b6923-aad7-4c62-907e-fb0c0ba08f44@",
                  "title" => "<span class=\"os-number\">7.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Glycolysis</span>",
                  "slug" => "7-2-glycolysis"
                },
                {
                  "id" => "c1e00705-ab75-4c24-8c6c-5d983c3cca49@",
                  "title" => "<span class=\"os-number\">7.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Oxidation of Pyruvate and the Citric Acid Cycle</span>",
                  "slug" => "7-3-oxidation-of-pyruvate-and-the-citric-acid-cycle"
                },
                {
                  "id" => "ee84d502-0ad9-4abb-a530-94252d9f08d9@",
                  "title" => "<span class=\"os-number\">7.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Oxidative Phosphorylation</span>",
                  "slug" => "7-4-oxidative-phosphorylation"
                },
                {
                  "id" => "8e609899-8a25-47cd-a019-11ed0e065755@",
                  "title" => "<span class=\"os-number\">7.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Metabolism without Oxygen</span>",
                  "slug" => "7-5-metabolism-without-oxygen"
                },
                {
                  "id" => "64fe39ec-5eb8-491e-93ba-a92598aaaa80@",
                  "title" => "<span class=\"os-number\">7.6</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Connections of Carbohydrate, Protein, and Lipid Metabolic Pathways</span>",
                  "slug" => "7-6-connections-of-carbohydrate-protein-and-lipid-metabolic-pathways"
                },
                {
                  "id" => "cd121ae8-7896-4d46-a606-17f78c37b826@",
                  "title" => "<span class=\"os-number\">7.7</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Regulation of Cellular Respiration</span>",
                  "slug" => "7-7-regulation-of-cellular-respiration"
                },
                {
                  "id" => "58e9e038-1b18-5489-afed-29a8a6f924d2@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "7-key-terms"
                },
                {
                  "id" => "6ed583d2-ddff-5545-9f80-49048fa3bd77@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "7-chapter-summary"
                },
                {
                  "id" => "f688ac78-4318-59b7-b7f9-1c6b329cb731@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "7-visual-connection-questions"
                },
                {
                  "id" => "c2f00861-7c2e-58fe-9310-4de62220d23b@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "7-review-questions"
                },
                {
                  "id" => "c7c71e26-ab5a-50ba-894e-3139bd3fb290@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "7-critical-thinking-questions"
                }
              ],
              "slug" => "7-cellular-respiration"
            },
            {
              "id" => "9bc06b92-4081-5e0b-90da-dcd3bb1890be@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>8</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Photosynthesis</span>",
              "contents" => [
                {
                  "id" => "48242857-59d1-4b46-a7e2-f27c33299f56@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "8-introduction"
                },
                {
                  "id" => "5bb72d25-e488-4760-8da8-51bc5b86c29d@",
                  "title" => "<span class=\"os-number\">8.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Overview of Photosynthesis</span>",
                  "slug" => "8-1-overview-of-photosynthesis"
                },
                {
                  "id" => "f829b3bd-472d-4885-a0a4-6fea3252e2b2@",
                  "title" => "<span class=\"os-number\">8.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Light-Dependent Reactions of Photosynthesis</span>",
                  "slug" => "8-2-the-light-dependent-reactions-of-photosynthesis"
                },
                {
                  "id" => "36b3469d-e561-44ff-ac32-99f4d18830e2@",
                  "title" => "<span class=\"os-number\">8.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Using Light Energy to Make Organic Molecules</span>",
                  "slug" => "8-3-using-light-energy-to-make-organic-molecules"
                },
                {
                  "id" => "f666dd17-2e7a-5010-8c87-b30fede79e20@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "8-key-terms"
                },
                {
                  "id" => "f7efb3a6-f6ab-5580-94b1-7f5bc4b86d2f@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "8-chapter-summary"
                },
                {
                  "id" => "7bb74fbb-6afc-58c5-a6c2-c673cd1016d6@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "8-visual-connection-questions"
                },
                {
                  "id" => "f7bf762b-337b-5812-8132-f03a4c4b7479@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "8-review-questions"
                },
                {
                  "id" => "c09302ed-cfb5-546c-8021-23a8aeb16721@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "8-critical-thinking-questions"
                }
              ],
              "slug" => "8-photosynthesis"
            },
            {
              "id" => "e6aeeadd-0434-5e25-9206-fd0890bb92dc@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>9</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Cell Communication</span>",
              "contents" => [
                {
                  "id" => "d5ef65df-70bb-4cd6-8377-4c0f315c9e97@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "9-introduction"
                },
                {
                  "id" => "1f8a0ca4-24a2-44fd-9706-f43ac0a5904e@",
                  "title" => "<span class=\"os-number\">9.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Signaling Molecules and Cellular Receptors</span>",
                  "slug" => "9-1-signaling-molecules-and-cellular-receptors"
                },
                {
                  "id" => "b13912c1-d7fb-4f5f-9b8a-04a0ee9ed00f@",
                  "title" => "<span class=\"os-number\">9.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Propagation of the Signal</span>",
                  "slug" => "9-2-propagation-of-the-signal"
                },
                {
                  "id" => "c90e0c3f-d259-40ae-845f-6cb0a364e388@",
                  "title" => "<span class=\"os-number\">9.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Response to the Signal</span>",
                  "slug" => "9-3-response-to-the-signal"
                },
                {
                  "id" => "1a3eb179-6a06-4a14-81bb-90fce075c39d@",
                  "title" => "<span class=\"os-number\">9.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Signaling in Single-Celled Organisms</span>",
                  "slug" => "9-4-signaling-in-single-celled-organisms"
                },
                {
                  "id" => "30a7660d-3ca0-5473-af1b-41b3833cefdd@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "9-key-terms"
                },
                {
                  "id" => "909afe68-4dfb-5376-8e12-e534986a3417@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "9-chapter-summary"
                },
                {
                  "id" => "b5a6b16b-1a29-53e2-bd80-2f41adf7085a@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "9-visual-connection-questions"
                },
                {
                  "id" => "5785ccdf-dee0-5385-80b2-1bd256568438@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "9-review-questions"
                },
                {
                  "id" => "fb86f9ec-c3d5-5bf8-99e2-1cac039b54d3@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "9-critical-thinking-questions"
                }
              ],
              "slug" => "9-cell-communication"
            },
            {
              "id" => "7340d08a-7e76-5f2a-ab5c-7e4889acafaa@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>10</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Cell Reproduction</span>",
              "contents" => [
                {
                  "id" => "87a4423a-158e-40b8-86c5-a1bd14cf6584@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "10-introduction"
                },
                {
                  "id" => "4caf480f-6848-4231-9fe3-345bd87cae80@",
                  "title" => "<span class=\"os-number\">10.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Cell Division</span>",
                  "slug" => "10-1-cell-division"
                },
                {
                  "id" => "d6d279e4-eb7a-4e64-8d53-8710b4c50e81@",
                  "title" => "<span class=\"os-number\">10.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Cell Cycle</span>",
                  "slug" => "10-2-the-cell-cycle"
                },
                {
                  "id" => "69b8e2ee-f350-4202-8085-878c433e1cd5@",
                  "title" => "<span class=\"os-number\">10.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Control of the Cell Cycle</span>",
                  "slug" => "10-3-control-of-the-cell-cycle"
                },
                {
                  "id" => "09866999-e751-4c08-b013-e46b93c08188@",
                  "title" => "<span class=\"os-number\">10.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Cancer and the Cell Cycle</span>",
                  "slug" => "10-4-cancer-and-the-cell-cycle"
                },
                {
                  "id" => "91c43929-51af-4cda-b1ba-ac8521bef464@",
                  "title" => "<span class=\"os-number\">10.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Prokaryotic Cell Division</span>",
                  "slug" => "10-5-prokaryotic-cell-division"
                },
                {
                  "id" => "27082fea-78ab-5c36-9347-11c9fdedd944@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "10-key-terms"
                },
                {
                  "id" => "bceb103a-a597-565c-a9ce-9045448e5346@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "10-chapter-summary"
                },
                {
                  "id" => "ee47fdee-66fc-5bb9-b819-2a7bc28f3eeb@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "10-visual-connection-questions"
                },
                {
                  "id" => "ec3e8ad2-6fa7-5b75-b82d-f32b0771821d@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "10-review-questions"
                },
                {
                  "id" => "cbbc4155-c793-5ac9-b7a8-a64c51bb0e47@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "10-critical-thinking-questions"
                }
              ],
              "slug" => "10-cell-reproduction"
            }
          ],
          "slug" => "2-unit-2-the-cell"
        },
        {
          "id" => "26dff32b-3e2d-5672-8e49-cb4340b253ca@e989ec3",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Unit </span>3</span>\n    <span class=\"os-divider\"> </span>\n    <span data-type=\"\" itemprop=\"\" class=\"os-text\">Unit 3. Genetics</span>",
          "contents" => [
            {
              "id" => "1be9a8d1-e5e8-5bd7-94b0-3a843e3d717a@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>11</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Meiosis and Sexual Reproduction</span>",
              "contents" => [
                {
                  "id" => "a29864f3-11df-4ded-a481-b9ddeba0d407@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "11-introduction"
                },
                {
                  "id" => "198652dc-30cf-4065-9bbf-80fe4e1f123b@",
                  "title" => "<span class=\"os-number\">11.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Process of Meiosis</span>",
                  "slug" => "11-1-the-process-of-meiosis"
                },
                {
                  "id" => "8fd39113-d8a6-4987-a41b-d0f4cea6062e@",
                  "title" => "<span class=\"os-number\">11.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Sexual Reproduction</span>",
                  "slug" => "11-2-sexual-reproduction"
                },
                {
                  "id" => "b0077354-3025-5857-bb26-76beab58b3dd@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "11-key-terms"
                },
                {
                  "id" => "93b0a5d1-51c1-5623-885c-dc5c7826a9a3@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "11-chapter-summary"
                },
                {
                  "id" => "4fcdb0d8-17d0-5d5b-95fc-f931355918ef@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "11-visual-connection-questions"
                },
                {
                  "id" => "94669760-ef30-55bc-8036-c3a8ece94623@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "11-review-questions"
                },
                {
                  "id" => "8c21ed84-9930-50d9-96b6-c801d0831998@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "11-critical-thinking-questions"
                }
              ],
              "slug" => "11-meiosis-and-sexual-reproduction"
            },
            {
              "id" => "a790dcc2-b3a9-56dd-9403-f266f608c0c1@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>12</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Mendel's Experiments and Heredity</span>",
              "contents" => [
                {
                  "id" => "3b695749-395f-41f8-9cb3-13ea11c30a34@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "12-introduction"
                },
                {
                  "id" => "c785a8d1-04ca-47ff-af0b-8de66795436a@",
                  "title" => "<span class=\"os-number\">12.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Mendel’s Experiments and the Laws of Probability</span>",
                  "slug" => "12-1-mendels-experiments-and-the-laws-of-probability"
                },
                {
                  "id" => "e2a834f2-7b7e-4ae4-bed8-f4d3c9fff598@",
                  "title" => "<span class=\"os-number\">12.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Characteristics and Traits</span>",
                  "slug" => "12-2-characteristics-and-traits"
                },
                {
                  "id" => "71479ebe-e682-4230-beab-d458bc170fe1@",
                  "title" => "<span class=\"os-number\">12.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Laws of Inheritance</span>",
                  "slug" => "12-3-laws-of-inheritance"
                },
                {
                  "id" => "a6dabf91-4bf7-50e6-9641-359f99c0f5fd@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "12-key-terms"
                },
                {
                  "id" => "771861e1-470d-57db-9a14-baa3ddfecca5@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "12-chapter-summary"
                },
                {
                  "id" => "37689f93-50e0-5338-beb6-8825fa079935@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "12-visual-connection-questions"
                },
                {
                  "id" => "553b12c0-4772-5727-a357-98026e141e40@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "12-review-questions"
                },
                {
                  "id" => "39a7f75e-3c5c-5036-9040-64cb3dd683ea@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "12-critical-thinking-questions"
                }
              ],
              "slug" => "12-mendels-experiments-and-heredity"
            },
            {
              "id" => "72b16345-860e-5e83-974a-ca42f22a08c7@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>13</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Modern Understandings of Inheritance</span>",
              "contents" => [
                {
                  "id" => "86f39385-c19c-4006-8c52-138cc6145958@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "13-introduction"
                },
                {
                  "id" => "a9d1d357-da72-47ee-8d93-4699f1da6244@",
                  "title" => "<span class=\"os-number\">13.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Chromosomal Theory and Genetic Linkage</span>",
                  "slug" => "13-1-chromosomal-theory-and-genetic-linkage"
                },
                {
                  "id" => "91f58935-5bef-40f2-88fd-8ef637648b9c@",
                  "title" => "<span class=\"os-number\">13.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Chromosomal Basis of Inherited Disorders</span>",
                  "slug" => "13-2-chromosomal-basis-of-inherited-disorders"
                },
                {
                  "id" => "643edc6e-a07c-5985-8f05-a7db8cb5956f@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "13-key-terms"
                },
                {
                  "id" => "60b4bcec-8282-527a-bd78-26aae0a7a083@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "13-chapter-summary"
                },
                {
                  "id" => "69c362eb-0009-58e9-8d95-5ef8e51aec89@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "13-visual-connection-questions"
                },
                {
                  "id" => "672f424f-d3a1-5338-96c0-0c30685e79de@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "13-review-questions"
                },
                {
                  "id" => "832cb804-7e5d-542e-830f-83473cf7c348@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "13-critical-thinking-questions"
                }
              ],
              "slug" => "13-modern-understandings-of-inheritance"
            },
            {
              "id" => "e30dc373-fba1-51d2-9907-4d988387c550@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>14</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">DNA Structure and Function</span>",
              "contents" => [
                {
                  "id" => "434d46d6-6ce1-4709-96a7-e78e5477d4ee@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "14-introduction"
                },
                {
                  "id" => "edcd817b-eeae-4d6f-8cbb-5cc0430a8564@",
                  "title" => "<span class=\"os-number\">14.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Historical Basis of Modern Understanding</span>",
                  "slug" => "14-1-historical-basis-of-modern-understanding"
                },
                {
                  "id" => "53bb4f0d-1c4a-4451-a97a-e24e2b9e7776@",
                  "title" => "<span class=\"os-number\">14.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">DNA Structure and Sequencing</span>",
                  "slug" => "14-2-dna-structure-and-sequencing"
                },
                {
                  "id" => "1723d815-cea1-4f32-891f-0373d7ef1137@",
                  "title" => "<span class=\"os-number\">14.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Basics of DNA Replication</span>",
                  "slug" => "14-3-basics-of-dna-replication"
                },
                {
                  "id" => "34493d96-5fb7-4dd4-9ed4-6f476d2afa8f@",
                  "title" => "<span class=\"os-number\">14.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">DNA Replication in Prokaryotes</span>",
                  "slug" => "14-4-dna-replication-in-prokaryotes"
                },
                {
                  "id" => "da5de7b1-f24a-4241-94ea-9740907f6bf9@",
                  "title" => "<span class=\"os-number\">14.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">DNA Replication in Eukaryotes</span>",
                  "slug" => "14-5-dna-replication-in-eukaryotes"
                },
                {
                  "id" => "30fcb950-c2a6-4dab-b62f-549c8ce3d7d1@",
                  "title" => "<span class=\"os-number\">14.6</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">DNA Repair</span>",
                  "slug" => "14-6-dna-repair"
                },
                {
                  "id" => "f8086000-7847-50a9-9948-607f8b3c6ee2@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "14-key-terms"
                },
                {
                  "id" => "7ce1b9f6-3e2c-5b9b-9ae6-82d8679bd0ec@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "14-chapter-summary"
                },
                {
                  "id" => "e2b458e8-6409-5353-9952-457b3b5c430b@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "14-visual-connection-questions"
                },
                {
                  "id" => "879e864b-5b1f-5944-80db-edcc3a51bfce@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "14-review-questions"
                },
                {
                  "id" => "f4d75e48-3fc2-514f-b118-0f405b429f24@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "14-critical-thinking-questions"
                }
              ],
              "slug" => "14-dna-structure-and-function"
            },
            {
              "id" => "3316c413-36da-5148-bc2b-c8d546b3bd3b@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>15</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Genes and Proteins</span>",
              "contents" => [
                {
                  "id" => "ecc98c47-ea58-4a61-ba67-76ffa037a28c@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "15-introduction"
                },
                {
                  "id" => "40489b84-9322-47be-96dc-4f80079cb868@",
                  "title" => "<span class=\"os-number\">15.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Genetic Code</span>",
                  "slug" => "15-1-the-genetic-code"
                },
                {
                  "id" => "48fcec00-b861-4d5f-b1d3-1df6bbb80eb4@",
                  "title" => "<span class=\"os-number\">15.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Prokaryotic Transcription</span>",
                  "slug" => "15-2-prokaryotic-transcription"
                },
                {
                  "id" => "ea5ef43f-dbba-447e-b163-d9dc09b49990@",
                  "title" => "<span class=\"os-number\">15.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Eukaryotic Transcription</span>",
                  "slug" => "15-3-eukaryotic-transcription"
                },
                {
                  "id" => "8c2adf0b-96af-411c-9151-e53d9ce362b4@",
                  "title" => "<span class=\"os-number\">15.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">RNA Processing in Eukaryotes</span>",
                  "slug" => "15-4-rna-processing-in-eukaryotes"
                },
                {
                  "id" => "d6603498-9a4c-4056-ac84-061ad4f8cdf9@",
                  "title" => "<span class=\"os-number\">15.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Ribosomes and Protein Synthesis</span>",
                  "slug" => "15-5-ribosomes-and-protein-synthesis"
                },
                {
                  "id" => "b06f8c0a-0a6e-5a35-9f29-adb344802f06@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "15-key-terms"
                },
                {
                  "id" => "daa66a82-6a04-5b31-8010-f164ed6bb655@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "15-chapter-summary"
                },
                {
                  "id" => "68988d69-3c2b-5220-8f2e-c7b51561d80a@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "15-visual-connection-questions"
                },
                {
                  "id" => "e767d0ce-a4fc-53f9-913b-e39fd0fdefcf@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "15-review-questions"
                },
                {
                  "id" => "4f7e7a21-d0ad-5bb0-9c90-20edaa030736@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "15-critical-thinking-questions"
                }
              ],
              "slug" => "15-genes-and-proteins"
            },
            {
              "id" => "51dd48c1-9b5d-5f72-85ab-348221b7cace@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>16</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Gene Expression</span>",
              "contents" => [
                {
                  "id" => "9a0de34f-fc57-4734-841e-78b9b4c3b7c8@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "16-introduction"
                },
                {
                  "id" => "750579d3-02ef-4a96-8dee-bd9b11f7be6c@",
                  "title" => "<span class=\"os-number\">16.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Regulation of Gene Expression</span>",
                  "slug" => "16-1-regulation-of-gene-expression"
                },
                {
                  "id" => "76b4a074-d223-4ad9-8d9e-4114c74f492c@",
                  "title" => "<span class=\"os-number\">16.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Prokaryotic Gene Regulation</span>",
                  "slug" => "16-2-prokaryotic-gene-regulation"
                },
                {
                  "id" => "112da94a-d347-4695-af35-9c97314f3e84@",
                  "title" => "<span class=\"os-number\">16.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Eukaryotic Epigenetic Gene Regulation</span>",
                  "slug" => "16-3-eukaryotic-epigenetic-gene-regulation"
                },
                {
                  "id" => "ed1cb7a1-1b1e-4426-9e90-4c7ee7cd1841@",
                  "title" => "<span class=\"os-number\">16.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Eukaryotic Transcription Gene Regulation</span>",
                  "slug" => "16-4-eukaryotic-transcription-gene-regulation"
                },
                {
                  "id" => "c1fdc133-0975-40e0-8e97-d091e2960734@",
                  "title" => "<span class=\"os-number\">16.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Eukaryotic Post-transcriptional Gene Regulation</span>",
                  "slug" => "16-5-eukaryotic-post-transcriptional-gene-regulation"
                },
                {
                  "id" => "f193c8c5-f472-43df-82b9-225103e22fd6@",
                  "title" => "<span class=\"os-number\">16.6</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Eukaryotic Translational and Post-translational Gene Regulation</span>",
                  "slug" => "16-6-eukaryotic-translational-and-post-translational-gene-regulation"
                },
                {
                  "id" => "21b659c0-10cc-43be-a34e-e41db8d149f3@",
                  "title" => "<span class=\"os-number\">16.7</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Cancer and Gene Regulation</span>",
                  "slug" => "16-7-cancer-and-gene-regulation"
                },
                {
                  "id" => "35f6f025-ec10-5baa-8b0e-723128329dd7@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "16-key-terms"
                },
                {
                  "id" => "be80587c-e754-516c-9cc9-c14be7d74e02@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "16-chapter-summary"
                },
                {
                  "id" => "dbd4bb8a-a385-5219-a25d-360de9160d5d@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "16-visual-connection-questions"
                },
                {
                  "id" => "0a9209fa-474e-5b9a-9b36-0d828927ded2@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "16-review-questions"
                },
                {
                  "id" => "5e05f51a-9d4c-5abe-905a-564e177dca95@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "16-critical-thinking-questions"
                }
              ],
              "slug" => "16-gene-expression"
            },
            {
              "id" => "aadc1e77-1ea1-59e1-b2da-7a08278c2544@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>17</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Biotechnology and Genomics</span>",
              "contents" => [
                {
                  "id" => "644feff4-c255-4063-811a-5104a2b430de@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "17-introduction"
                },
                {
                  "id" => "7b18387b-8014-4514-b0fe-2dbef5e9d532@",
                  "title" => "<span class=\"os-number\">17.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Biotechnology</span>",
                  "slug" => "17-1-biotechnology"
                },
                {
                  "id" => "42ae98d4-0d7a-4b6b-ba20-881b5e3be123@",
                  "title" => "<span class=\"os-number\">17.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Mapping Genomes</span>",
                  "slug" => "17-2-mapping-genomes"
                },
                {
                  "id" => "e65f38e1-9dfc-4da9-995c-f51db70d5abc@",
                  "title" => "<span class=\"os-number\">17.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Whole-Genome Sequencing</span>",
                  "slug" => "17-3-whole-genome-sequencing"
                },
                {
                  "id" => "29cd41e7-21fb-499e-9929-353ee596dbbe@",
                  "title" => "<span class=\"os-number\">17.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Applying Genomics</span>",
                  "slug" => "17-4-applying-genomics"
                },
                {
                  "id" => "74a63fe7-167c-4666-a28e-1f634d43c6c0@",
                  "title" => "<span class=\"os-number\">17.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Genomics and Proteomics</span>",
                  "slug" => "17-5-genomics-and-proteomics"
                },
                {
                  "id" => "cf5a79bd-aeac-5c7b-a0d6-e50ac6a6a83b@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "17-key-terms"
                },
                {
                  "id" => "461bed25-aa39-5a09-aa1b-71e6695761ef@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "17-chapter-summary"
                },
                {
                  "id" => "989ac35a-86bf-5ac9-a637-d4235adf9491@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "17-visual-connection-questions"
                },
                {
                  "id" => "585d2c00-9fa4-589a-98fa-89c74cfd9bf0@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "17-review-questions"
                },
                {
                  "id" => "f99f26bf-b6a8-5fcb-9ea1-81efd17170e8@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "17-critical-thinking-questions"
                }
              ],
              "slug" => "17-biotechnology-and-genomics"
            }
          ],
          "slug" => "3-unit-3-genetics"
        },
        {
          "id" => "0aadc6c5-b12b-53e9-a570-2e65dd6ffbca@e989ec3",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Unit </span>4</span>\n    <span class=\"os-divider\"> </span>\n    <span data-type=\"\" itemprop=\"\" class=\"os-text\">Unit 4. Evolutionary Processes</span>",
          "contents" => [
            {
              "id" => "da278463-6172-519e-9604-9bbebc66bbb5@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>18</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Evolution and the Origin of Species</span>",
              "contents" => [
                {
                  "id" => "b2589c4b-ef62-48a1-982a-724236ff26b5@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "18-introduction"
                },
                {
                  "id" => "9e805c7d-3865-4666-85ba-34c01660bf84@",
                  "title" => "<span class=\"os-number\">18.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Understanding Evolution</span>",
                  "slug" => "18-1-understanding-evolution"
                },
                {
                  "id" => "977917b4-2c6e-4646-a100-636fa26717d4@",
                  "title" => "<span class=\"os-number\">18.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Formation of New Species</span>",
                  "slug" => "18-2-formation-of-new-species"
                },
                {
                  "id" => "9d38a9c1-e81a-4cb7-8aa0-dae690bc4371@",
                  "title" => "<span class=\"os-number\">18.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Reconnection and Rates of Speciation</span>",
                  "slug" => "18-3-reconnection-and-rates-of-speciation"
                },
                {
                  "id" => "07030520-648f-55eb-bb59-cdcc7688cc25@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "18-key-terms"
                },
                {
                  "id" => "f3e01f06-ea92-5690-93e9-926b238cd92b@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "18-chapter-summary"
                },
                {
                  "id" => "3b1f1764-1d26-5696-a913-ee6e4af2e361@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "18-visual-connection-questions"
                },
                {
                  "id" => "581263a7-eb16-5c0a-855d-103ac92dc103@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "18-review-questions"
                },
                {
                  "id" => "735a0886-85c4-51e2-b7eb-e3e5b971e7e0@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "18-critical-thinking-questions"
                }
              ],
              "slug" => "18-evolution-and-the-origin-of-species"
            },
            {
              "id" => "59afc393-0d18-5675-9736-8fe04e2977d6@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>19</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">The Evolution of Populations</span>",
              "contents" => [
                {
                  "id" => "38ad6783-a1f0-472e-8d3c-28cf336f1d3c@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "19-introduction"
                },
                {
                  "id" => "22277798-cbf5-46d5-8abd-9a50a79b2b54@",
                  "title" => "<span class=\"os-number\">19.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Population Evolution</span>",
                  "slug" => "19-1-population-evolution"
                },
                {
                  "id" => "c8d952c6-3d04-4c9f-b5dd-3c5350180468@",
                  "title" => "<span class=\"os-number\">19.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Population Genetics</span>",
                  "slug" => "19-2-population-genetics"
                },
                {
                  "id" => "fa528285-084b-478c-adc2-da78c46915ca@",
                  "title" => "<span class=\"os-number\">19.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Adaptive Evolution</span>",
                  "slug" => "19-3-adaptive-evolution"
                },
                {
                  "id" => "e3aa59fd-bfb5-5c8c-ba4d-0a33b7e24e3d@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "19-key-terms"
                },
                {
                  "id" => "7d56bda7-f562-582f-a0b9-a6a2292addce@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "19-chapter-summary"
                },
                {
                  "id" => "6a4b4b9c-15cc-5afc-a439-042932cd20a7@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "19-visual-connection-questions"
                },
                {
                  "id" => "2bc9f0a9-00df-5ae9-905b-2ac5f5dc5a92@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "19-review-questions"
                },
                {
                  "id" => "d08ff8fb-e57c-5a04-8911-069f8cf55d4d@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "19-critical-thinking-questions"
                }
              ],
              "slug" => "19-the-evolution-of-populations"
            },
            {
              "id" => "9e6a5b6d-1948-53f8-97be-887d5f6e9514@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>20</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Phylogenies and the History of Life</span>",
              "contents" => [
                {
                  "id" => "5e2228c5-a640-42d4-8fec-2e8b668708d7@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "20-introduction"
                },
                {
                  "id" => "67322fde-a447-4caa-94f6-2c072d3bda66@",
                  "title" => "<span class=\"os-number\">20.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Organizing Life on Earth</span>",
                  "slug" => "20-1-organizing-life-on-earth"
                },
                {
                  "id" => "b4e739c3-be08-4216-9e15-288ac678bb30@",
                  "title" => "<span class=\"os-number\">20.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Determining Evolutionary Relationships</span>",
                  "slug" => "20-2-determining-evolutionary-relationships"
                },
                {
                  "id" => "275b6240-caa4-4937-94bb-eaeb86b2f34b@",
                  "title" => "<span class=\"os-number\">20.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Perspectives on the Phylogenetic Tree</span>",
                  "slug" => "20-3-perspectives-on-the-phylogenetic-tree"
                },
                {
                  "id" => "7b406e7f-ee75-5612-8c12-c63aa6348022@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "20-key-terms"
                },
                {
                  "id" => "00d49889-e8ad-57fc-bd86-0333b47927cc@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "20-chapter-summary"
                },
                {
                  "id" => "c4f479b1-951c-5aa5-b9f2-e02c9ffa884e@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "20-visual-connection-questions"
                },
                {
                  "id" => "939745f8-072b-5f8a-84b5-e64bbd9978d8@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "20-review-questions"
                },
                {
                  "id" => "ac761f42-8fb9-57bf-9ea8-daf7dcce9dec@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "20-critical-thinking-questions"
                }
              ],
              "slug" => "20-phylogenies-and-the-history-of-life"
            }
          ],
          "slug" => "4-unit-4-evolutionary-processes"
        },
        {
          "id" => "854ac6e7-ea3b-5349-be63-5d15b7797092@e989ec3",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Unit </span>5</span>\n    <span class=\"os-divider\"> </span>\n    <span data-type=\"\" itemprop=\"\" class=\"os-text\">Unit 5. Biological Diversity</span>",
          "contents" => [
            {
              "id" => "aca2d7c8-e7ea-506f-94b7-08a1ae7a63cc@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>21</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Viruses</span>",
              "contents" => [
                {
                  "id" => "ed0fb5c2-ce30-4a76-8d58-77fb7cf9c7ec@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "21-introduction"
                },
                {
                  "id" => "78aa7335-3dd1-4dc4-bd12-f3dee2587553@",
                  "title" => "<span class=\"os-number\">21.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Viral Evolution, Morphology, and Classification</span>",
                  "slug" => "21-1-viral-evolution-morphology-and-classification"
                },
                {
                  "id" => "7cbd15ad-5bff-4678-a99f-85fd579e070c@",
                  "title" => "<span class=\"os-number\">21.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Virus Infections and Hosts</span>",
                  "slug" => "21-2-virus-infections-and-hosts"
                },
                {
                  "id" => "e0a7df01-1e56-47b2-81a1-95701e64b277@",
                  "title" => "<span class=\"os-number\">21.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Prevention and Treatment of Viral Infections</span>",
                  "slug" => "21-3-prevention-and-treatment-of-viral-infections"
                },
                {
                  "id" => "c7560d4a-bcd5-4739-83f4-3e44f44dc130@",
                  "title" => "<span class=\"os-number\">21.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Other Acellular Entities: Prions and Viroids</span>",
                  "slug" => "21-4-other-acellular-entities-prions-and-viroids"
                },
                {
                  "id" => "ae677751-1785-59fb-8e32-f7df22585aa1@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "21-key-terms"
                },
                {
                  "id" => "8ae44d80-4ae0-518c-ae55-aae257d5a5c2@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "21-chapter-summary"
                },
                {
                  "id" => "7db678b3-ef31-5bfb-a332-7545c8786225@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "21-visual-connection-questions"
                },
                {
                  "id" => "c84cdebf-cc9e-5321-bfa7-ad3887b36244@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "21-review-questions"
                },
                {
                  "id" => "ce964293-36ce-5ed0-80a5-446a8ce81428@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "21-critical-thinking-questions"
                }
              ],
              "slug" => "21-viruses"
            },
            {
              "id" => "e4695d29-d401-5faa-89e6-3c8be88e8c2f@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>22</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Prokaryotes: Bacteria and Archaea</span>",
              "contents" => [
                {
                  "id" => "2f332c42-3765-45dd-92a3-d1dfbe7678c1@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "22-introduction"
                },
                {
                  "id" => "b94b96b8-c5fa-4bed-a047-97c324ffdc9d@",
                  "title" => "<span class=\"os-number\">22.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Prokaryotic Diversity</span>",
                  "slug" => "22-1-prokaryotic-diversity"
                },
                {
                  "id" => "9e7c7540-5794-4c31-917d-fce7e50ea6dd@",
                  "title" => "<span class=\"os-number\">22.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Structure of Prokaryotes</span>",
                  "slug" => "22-2-structure-of-prokaryotes"
                },
                {
                  "id" => "47cb544e-2d71-4962-8d42-87f00bad4045@",
                  "title" => "<span class=\"os-number\">22.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Prokaryotic Metabolism</span>",
                  "slug" => "22-3-prokaryotic-metabolism"
                },
                {
                  "id" => "0a866b1c-8f44-489a-ae8c-6e100ca0ee55@",
                  "title" => "<span class=\"os-number\">22.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Bacterial Diseases in Humans</span>",
                  "slug" => "22-4-bacterial-diseases-in-humans"
                },
                {
                  "id" => "c839b5e3-3aa6-4855-a254-0a493ff1ad17@",
                  "title" => "<span class=\"os-number\">22.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Beneficial Prokaryotes</span>",
                  "slug" => "22-5-beneficial-prokaryotes"
                },
                {
                  "id" => "72baf0d3-1c36-5a24-92ad-9d5531725d86@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "22-key-terms"
                },
                {
                  "id" => "505a0456-8be3-5c59-92c5-ce116fa61a76@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "22-chapter-summary"
                },
                {
                  "id" => "68329f44-891f-5ca9-ba10-7a4e703f4ba1@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "22-visual-connection-questions"
                },
                {
                  "id" => "52a7b304-d0e7-5ba4-b051-adb486ac0d6d@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "22-review-questions"
                },
                {
                  "id" => "7ea0249c-4f89-55d4-a361-527adcb205d0@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "22-critical-thinking-questions"
                }
              ],
              "slug" => "22-prokaryotes-bacteria-and-archaea"
            },
            {
              "id" => "58531c71-8fbf-58b9-9251-d3bc999cd5bd@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>23</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Protists</span>",
              "contents" => [
                {
                  "id" => "2d9e50a6-fddc-4a36-8b85-609879ff3c32@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "23-introduction"
                },
                {
                  "id" => "a0746ee5-d512-4fe7-91ba-91649630ca0c@",
                  "title" => "<span class=\"os-number\">23.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Eukaryotic Origins</span>",
                  "slug" => "23-1-eukaryotic-origins"
                },
                {
                  "id" => "1e2d9bb8-0150-48c6-909e-1501c626c11b@",
                  "title" => "<span class=\"os-number\">23.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Characteristics of Protists</span>",
                  "slug" => "23-2-characteristics-of-protists"
                },
                {
                  "id" => "1e968d8c-f2be-41e8-9610-3bff97d4d373@",
                  "title" => "<span class=\"os-number\">23.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Groups of Protists</span>",
                  "slug" => "23-3-groups-of-protists"
                },
                {
                  "id" => "d668ad34-2c26-45db-9fc7-95e3cbfc0149@",
                  "title" => "<span class=\"os-number\">23.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Ecology of Protists</span>",
                  "slug" => "23-4-ecology-of-protists"
                },
                {
                  "id" => "cc416398-ca95-58db-b1f4-d21e78b34d46@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "23-key-terms"
                },
                {
                  "id" => "9a7fdd09-6bb6-55a4-b794-021b69484c29@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "23-chapter-summary"
                },
                {
                  "id" => "4c261f3e-6c2d-54d3-a5de-a2e4d9322317@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "23-visual-connection-questions"
                },
                {
                  "id" => "198704c4-43cd-559c-b5c9-3566b3fa8366@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "23-review-questions"
                },
                {
                  "id" => "c7f1e114-7009-5a29-863a-5dd9ca12608e@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "23-critical-thinking-questions"
                }
              ],
              "slug" => "23-protists"
            },
            {
              "id" => "0b77582b-7a6b-5066-9f5a-af1253beb666@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>24</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Fungi</span>",
              "contents" => [
                {
                  "id" => "ed9fa295-e334-4650-b81d-0ede564fb71f@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "24-introduction"
                },
                {
                  "id" => "fa5f3021-e491-4c4d-bd3b-9b99bc75b3c9@",
                  "title" => "<span class=\"os-number\">24.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Characteristics of Fungi</span>",
                  "slug" => "24-1-characteristics-of-fungi"
                },
                {
                  "id" => "0137fd51-7ed5-44de-b9a8-41c9311dcd3f@",
                  "title" => "<span class=\"os-number\">24.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Classifications of Fungi</span>",
                  "slug" => "24-2-classifications-of-fungi"
                },
                {
                  "id" => "54faf509-a2ed-414d-8885-02445499420e@",
                  "title" => "<span class=\"os-number\">24.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Ecology of Fungi</span>",
                  "slug" => "24-3-ecology-of-fungi"
                },
                {
                  "id" => "b81e6e0d-428f-4e3e-933f-c5e85ff4cad0@",
                  "title" => "<span class=\"os-number\">24.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Fungal Parasites and Pathogens</span>",
                  "slug" => "24-4-fungal-parasites-and-pathogens"
                },
                {
                  "id" => "3f0c5f6b-e799-46d8-85c2-b416e19bc880@",
                  "title" => "<span class=\"os-number\">24.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Importance of Fungi in Human Life</span>",
                  "slug" => "24-5-importance-of-fungi-in-human-life"
                },
                {
                  "id" => "5e3f0723-01f3-5250-83a1-5f4ad24887f0@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "24-key-terms"
                },
                {
                  "id" => "5d865273-0368-5731-9ff5-92fe30ab7236@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "24-chapter-summary"
                },
                {
                  "id" => "7f10ab90-5f22-596c-8ae9-f36ffab75262@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "24-visual-connection-questions"
                },
                {
                  "id" => "823edce1-89d6-5393-8e85-ae2b6b454258@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "24-review-questions"
                },
                {
                  "id" => "b03fd31e-d163-5904-9778-9714b8388c3e@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "24-critical-thinking-questions"
                }
              ],
              "slug" => "24-fungi"
            },
            {
              "id" => "299a4dca-2056-5ff6-8974-cd8714853828@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>25</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Seedless Plants</span>",
              "contents" => [
                {
                  "id" => "204fed82-9cb3-41b3-b278-b117d2a7c1aa@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "25-introduction"
                },
                {
                  "id" => "b12983b8-a6da-46f6-9873-7f9d5776b9ec@",
                  "title" => "<span class=\"os-number\">25.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Early Plant Life</span>",
                  "slug" => "25-1-early-plant-life"
                },
                {
                  "id" => "5ff37d64-d2f7-44e3-8444-f0e63d5979cf@",
                  "title" => "<span class=\"os-number\">25.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Green Algae: Precursors of Land Plants</span>",
                  "slug" => "25-2-green-algae-precursors-of-land-plants"
                },
                {
                  "id" => "1c7d3088-26b5-430a-a41d-1232a353e595@",
                  "title" => "<span class=\"os-number\">25.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Bryophytes</span>",
                  "slug" => "25-3-bryophytes"
                },
                {
                  "id" => "e06bde91-e72c-46d4-85e4-08096675957e@",
                  "title" => "<span class=\"os-number\">25.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Seedless Vascular Plants</span>",
                  "slug" => "25-4-seedless-vascular-plants"
                },
                {
                  "id" => "ee158315-165a-5557-babd-f1cebf7c5ea8@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "25-key-terms"
                },
                {
                  "id" => "77e56b4e-fcf7-512b-8091-7aaaaa639296@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "25-chapter-summary"
                },
                {
                  "id" => "10a16ca4-5b2c-501f-8ab9-4c61730a9174@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "25-visual-connection-questions"
                },
                {
                  "id" => "ed265955-9445-550a-a171-54c1e1aea600@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "25-review-questions"
                },
                {
                  "id" => "5343a5b0-a7c9-5965-a735-6e5cfbfe833a@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "25-critical-thinking-questions"
                }
              ],
              "slug" => "25-seedless-plants"
            },
            {
              "id" => "4bdb7012-9213-51ca-bd61-06320a4e26dc@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>26</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Seed Plants</span>",
              "contents" => [
                {
                  "id" => "07323435-7692-4d81-a44d-4c4250c37c8e@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "26-introduction"
                },
                {
                  "id" => "1c45a66a-7a23-48ef-9948-8ae39ee01eb4@",
                  "title" => "<span class=\"os-number\">26.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Evolution of Seed Plants</span>",
                  "slug" => "26-1-evolution-of-seed-plants"
                },
                {
                  "id" => "b4bc502e-4b01-4832-be25-90b16239f1dd@",
                  "title" => "<span class=\"os-number\">26.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Gymnosperms</span>",
                  "slug" => "26-2-gymnosperms"
                },
                {
                  "id" => "b3298ec7-b55c-4ce7-89fd-1d4fad39630f@",
                  "title" => "<span class=\"os-number\">26.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Angiosperms</span>",
                  "slug" => "26-3-angiosperms"
                },
                {
                  "id" => "b3e7f392-d140-4ab4-b49b-d12c0e89c1a1@",
                  "title" => "<span class=\"os-number\">26.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Role of Seed Plants</span>",
                  "slug" => "26-4-the-role-of-seed-plants"
                },
                {
                  "id" => "bfd9b6aa-0947-5981-9e31-4dd669bb906e@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "26-key-terms"
                },
                {
                  "id" => "5de7fd5e-47cb-597c-a7d7-a9c5966d8254@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "26-chapter-summary"
                },
                {
                  "id" => "8ee3f87c-40ad-56f4-99b6-8172f4edc8b8@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "26-visual-connection-questions"
                },
                {
                  "id" => "405627c6-fbac-5ce1-ae4b-afe998f4c6cd@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "26-review-questions"
                },
                {
                  "id" => "653aa263-711b-5fd6-a3ae-53544bdc2e2d@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "26-critical-thinking-questions"
                }
              ],
              "slug" => "26-seed-plants"
            },
            {
              "id" => "32a41c58-3a04-5885-8387-f19455e7ca67@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>27</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Introduction to Animal Diversity</span>",
              "contents" => [
                {
                  "id" => "582b3b99-c003-4538-8965-2375382204ee@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "27-introduction"
                },
                {
                  "id" => "d09cbd3e-a293-4aab-9ae6-e1a46e9e1da9@",
                  "title" => "<span class=\"os-number\">27.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Features of the Animal Kingdom</span>",
                  "slug" => "27-1-features-of-the-animal-kingdom"
                },
                {
                  "id" => "7289a2d7-803c-49ef-905a-01324d155936@",
                  "title" => "<span class=\"os-number\">27.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Features Used to Classify Animals</span>",
                  "slug" => "27-2-features-used-to-classify-animals"
                },
                {
                  "id" => "0b4f514a-f4d4-455a-8814-97fa5df05345@",
                  "title" => "<span class=\"os-number\">27.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Animal Phylogeny</span>",
                  "slug" => "27-3-animal-phylogeny"
                },
                {
                  "id" => "0a0b301a-b084-4d30-82d5-430c4d266f35@",
                  "title" => "<span class=\"os-number\">27.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Evolutionary History of the Animal Kingdom</span>",
                  "slug" => "27-4-the-evolutionary-history-of-the-animal-kingdom"
                },
                {
                  "id" => "869a1b64-9b2b-5c50-9bcc-caece77b2c74@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "27-key-terms"
                },
                {
                  "id" => "c601f099-5608-5c0b-bac6-b7160678db63@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "27-chapter-summary"
                },
                {
                  "id" => "cac39797-ceaa-572a-afaa-1b45e3f0414b@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "27-visual-connection-questions"
                },
                {
                  "id" => "23342ce0-9865-5876-a645-b845d20e0957@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "27-review-questions"
                },
                {
                  "id" => "ef5bd7e0-be36-57cc-ab32-91c30d60d6bd@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "27-critical-thinking-questions"
                }
              ],
              "slug" => "27-introduction-to-animal-diversity"
            },
            {
              "id" => "c308e50a-26ac-5ae3-84d4-3bab80b4599b@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>28</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Invertebrates</span>",
              "contents" => [
                {
                  "id" => "11247285-083e-4281-ba13-20a70d0377d8@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "28-introduction"
                },
                {
                  "id" => "bb72c222-96b6-4e61-828b-0a667ec1ef22@",
                  "title" => "<span class=\"os-number\">28.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Phylum Porifera</span>",
                  "slug" => "28-1-phylum-porifera"
                },
                {
                  "id" => "a7777b21-e8d8-4e7f-a40f-5d3fdf86b904@",
                  "title" => "<span class=\"os-number\">28.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Phylum Cnidaria</span>",
                  "slug" => "28-2-phylum-cnidaria"
                },
                {
                  "id" => "d1219426-4d63-40e3-83b4-dc367df7b1fa@",
                  "title" => "<span class=\"os-number\">28.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Superphylum Lophotrochozoa</span>",
                  "slug" => "28-3-superphylum-lophotrochozoa"
                },
                {
                  "id" => "39403bd7-2528-49f8-b59d-c9ac37663e15@",
                  "title" => "<span class=\"os-number\">28.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Superphylum Ecdysozoa</span>",
                  "slug" => "28-4-superphylum-ecdysozoa"
                },
                {
                  "id" => "88c2f090-b457-4f4e-9b9a-bce5949481e2@",
                  "title" => "<span class=\"os-number\">28.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Superphylum Deuterostomia</span>",
                  "slug" => "28-5-superphylum-deuterostomia"
                },
                {
                  "id" => "cb620277-0bb9-5ec1-a380-a43f4f4cfbba@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "28-key-terms"
                },
                {
                  "id" => "cb1f06a6-66a1-520e-b693-5fde35e723f8@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "28-chapter-summary"
                },
                {
                  "id" => "e3fce574-bf41-5825-8628-9e340375e175@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "28-visual-connection-questions"
                },
                {
                  "id" => "806ed1fa-080f-5d9e-b1d6-858f5b529427@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "28-review-questions"
                },
                {
                  "id" => "20dd561c-1e51-5643-aa53-ecfb7ddde6ff@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "28-critical-thinking-questions"
                }
              ],
              "slug" => "28-invertebrates"
            },
            {
              "id" => "26a22ce1-6799-5fc3-b079-ba745601b9d6@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>29</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Vertebrates</span>",
              "contents" => [
                {
                  "id" => "ce4b10f1-479c-47df-8da1-874637759176@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "29-introduction"
                },
                {
                  "id" => "541db286-b021-462f-84f6-0d8540de9314@",
                  "title" => "<span class=\"os-number\">29.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Chordates</span>",
                  "slug" => "29-1-chordates"
                },
                {
                  "id" => "856f19b8-cb2d-40b4-b9f7-b466c13045cd@",
                  "title" => "<span class=\"os-number\">29.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Fishes</span>",
                  "slug" => "29-2-fishes"
                },
                {
                  "id" => "4c8391c9-f95a-4309-857a-840275fe776b@",
                  "title" => "<span class=\"os-number\">29.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Amphibians</span>",
                  "slug" => "29-3-amphibians"
                },
                {
                  "id" => "7c002ad9-7046-4631-ae85-192159967cab@",
                  "title" => "<span class=\"os-number\">29.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Reptiles</span>",
                  "slug" => "29-4-reptiles"
                },
                {
                  "id" => "16822841-8449-434a-a45f-9e1633044c32@",
                  "title" => "<span class=\"os-number\">29.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Birds</span>",
                  "slug" => "29-5-birds"
                },
                {
                  "id" => "a7a48cd6-4931-4e0c-8499-9bb42411f0c5@",
                  "title" => "<span class=\"os-number\">29.6</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Mammals</span>",
                  "slug" => "29-6-mammals"
                },
                {
                  "id" => "27ad04dc-d4c0-4fe1-af9c-cb65128de719@",
                  "title" => "<span class=\"os-number\">29.7</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Evolution of Primates</span>",
                  "slug" => "29-7-the-evolution-of-primates"
                },
                {
                  "id" => "75ed1d67-430c-5ec5-81a7-d88cf7f12dea@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "29-key-terms"
                },
                {
                  "id" => "419b4d90-c628-515c-b09a-8ff81e6f5d25@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "29-chapter-summary"
                },
                {
                  "id" => "d12a6fb2-6074-5966-98ec-8ad0cf2059d8@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "29-visual-connection-questions"
                },
                {
                  "id" => "27636e9b-d0b2-56cd-a11a-6f0ef2673c00@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "29-review-questions"
                },
                {
                  "id" => "738d8609-eba9-5bfc-86cc-d09ca28d7f81@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "29-critical-thinking-questions"
                }
              ],
              "slug" => "29-vertebrates"
            }
          ],
          "slug" => "5-unit-5-biological-diversity"
        },
        {
          "id" => "03130f75-5911-59aa-aef3-c4e562153469@e989ec3",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Unit </span>6</span>\n    <span class=\"os-divider\"> </span>\n    <span data-type=\"\" itemprop=\"\" class=\"os-text\">Unit 6. Plant Structure and Function</span>",
          "contents" => [
            {
              "id" => "3eebb432-585c-55f1-9725-a5207e52ba9f@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>30</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Plant Form and Physiology</span>",
              "contents" => [
                {
                  "id" => "8cfff5fa-6a5f-491c-a768-44929964104d@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "30-introduction"
                },
                {
                  "id" => "cd0fea74-368e-4015-ae27-e41b3d893b36@",
                  "title" => "<span class=\"os-number\">30.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Plant Body</span>",
                  "slug" => "30-1-the-plant-body"
                },
                {
                  "id" => "135eeaa9-79a4-4d8d-af7d-a0b6cf9e22d6@",
                  "title" => "<span class=\"os-number\">30.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Stems</span>",
                  "slug" => "30-2-stems"
                },
                {
                  "id" => "addad899-ddc7-489f-918a-30ff0b88911b@",
                  "title" => "<span class=\"os-number\">30.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Roots</span>",
                  "slug" => "30-3-roots"
                },
                {
                  "id" => "b9423ada-def0-4c06-98b2-5b59c5d07596@",
                  "title" => "<span class=\"os-number\">30.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Leaves</span>",
                  "slug" => "30-4-leaves"
                },
                {
                  "id" => "e5aabc6f-71d9-40d5-99f0-0fb2d8d47317@",
                  "title" => "<span class=\"os-number\">30.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Transport of Water and Solutes in Plants</span>",
                  "slug" => "30-5-transport-of-water-and-solutes-in-plants"
                },
                {
                  "id" => "c63b7f28-16a2-4602-b996-cdc7eb78219b@",
                  "title" => "<span class=\"os-number\">30.6</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Plant Sensory Systems and Responses</span>",
                  "slug" => "30-6-plant-sensory-systems-and-responses"
                },
                {
                  "id" => "b13d9cca-89ac-5cac-971f-466d27cbdcd6@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "30-key-terms"
                },
                {
                  "id" => "1fc3678c-39d3-5932-a3d7-bcbcca7ec89d@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "30-chapter-summary"
                },
                {
                  "id" => "4f8e2f5a-f918-559e-9f85-271ec0f5c893@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "30-visual-connection-questions"
                },
                {
                  "id" => "79a5024f-907e-5107-a2fe-becee01f6ebf@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "30-review-questions"
                },
                {
                  "id" => "cc14ce9a-2b06-5b40-9b54-aa56ec2bb0a5@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "30-critical-thinking-questions"
                }
              ],
              "slug" => "30-plant-form-and-physiology"
            },
            {
              "id" => "c6755ece-ed43-575f-91c0-1ddf4522cddb@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>31</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Soil and Plant Nutrition</span>",
              "contents" => [
                {
                  "id" => "349efd3e-f7ce-43cd-8b7b-98424310a985@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "31-introduction"
                },
                {
                  "id" => "57874cae-4b45-4edf-af71-f5df36ec4eb9@",
                  "title" => "<span class=\"os-number\">31.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Nutritional Requirements of Plants</span>",
                  "slug" => "31-1-nutritional-requirements-of-plants"
                },
                {
                  "id" => "3ceada67-61b1-478f-9aaf-604f5f34d116@",
                  "title" => "<span class=\"os-number\">31.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Soil</span>",
                  "slug" => "31-2-the-soil"
                },
                {
                  "id" => "bb913977-c624-45ce-99f2-425cb520b807@",
                  "title" => "<span class=\"os-number\">31.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Nutritional Adaptations of Plants</span>",
                  "slug" => "31-3-nutritional-adaptations-of-plants"
                },
                {
                  "id" => "9a3d9464-7ffc-5fd6-a1af-959a5de8e236@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "31-key-terms"
                },
                {
                  "id" => "c7213441-64e7-50e9-b62a-4004899c2967@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "31-chapter-summary"
                },
                {
                  "id" => "7df0edf6-a7eb-5e6b-a41a-74f9059c4171@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "31-visual-connection-questions"
                },
                {
                  "id" => "3114ca2c-9f9b-526f-b8d8-6666a6740574@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "31-review-questions"
                },
                {
                  "id" => "e9fd016d-cebd-50e3-92e6-3b40d72ce30a@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "31-critical-thinking-questions"
                }
              ],
              "slug" => "31-soil-and-plant-nutrition"
            },
            {
              "id" => "14a45db9-9f2b-5643-bdb5-3643a7189ec3@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>32</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Plant Reproduction</span>",
              "contents" => [
                {
                  "id" => "baffdcc7-0c68-416f-996e-0aa99cf96a5d@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "32-introduction"
                },
                {
                  "id" => "f4f12383-bcdd-4ea4-a192-96a8f307e07f@",
                  "title" => "<span class=\"os-number\">32.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Reproductive Development and Structure</span>",
                  "slug" => "32-1-reproductive-development-and-structure"
                },
                {
                  "id" => "4cb8905e-544e-4dc7-98ed-0889d3a4981a@",
                  "title" => "<span class=\"os-number\">32.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Pollination and Fertilization</span>",
                  "slug" => "32-2-pollination-and-fertilization"
                },
                {
                  "id" => "32be2767-4952-4dba-a93f-5fb6593e3fd6@",
                  "title" => "<span class=\"os-number\">32.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Asexual Reproduction</span>",
                  "slug" => "32-3-asexual-reproduction"
                },
                {
                  "id" => "6be8ca64-a52e-53b9-99e3-cd699794301a@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "32-key-terms"
                },
                {
                  "id" => "c3b18aad-6b8b-5175-ba98-fd270c5bfb07@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "32-chapter-summary"
                },
                {
                  "id" => "f2a121ae-a5d1-5884-8a24-10a5569642b1@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "32-visual-connection-questions"
                },
                {
                  "id" => "d8828ad6-208e-5762-bf9d-bf822916ae12@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "32-review-questions"
                },
                {
                  "id" => "fde1cb90-b440-50f6-a6ad-a1cb43f3759d@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "32-critical-thinking-questions"
                }
              ],
              "slug" => "32-plant-reproduction"
            }
          ],
          "slug" => "6-unit-6-plant-structure-and-function"
        },
        {
          "id" => "74dd89f4-e18c-500b-a0a2-5104ef20e6ec@e989ec3",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Unit </span>7</span>\n    <span class=\"os-divider\"> </span>\n    <span data-type=\"\" itemprop=\"\" class=\"os-text\">Unit 7. Animal Structure and Function</span>",
          "contents" => [
            {
              "id" => "b90c0ebd-8fec-50ce-a1bc-e8c8319ba846@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>33</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">The Animal Body: Basic Form and Function</span>",
              "contents" => [
                {
                  "id" => "60a1d14d-c74f-473c-a94b-029b4a704a35@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "33-introduction"
                },
                {
                  "id" => "44503b54-9a4c-40c4-ae59-369526d2f9ef@",
                  "title" => "<span class=\"os-number\">33.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Animal Form and Function</span>",
                  "slug" => "33-1-animal-form-and-function"
                },
                {
                  "id" => "f8b7e159-1112-46ea-be19-5f492747a7b5@",
                  "title" => "<span class=\"os-number\">33.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Animal Primary Tissues</span>",
                  "slug" => "33-2-animal-primary-tissues"
                },
                {
                  "id" => "04fdb865-17a1-43d8-bb33-36f821ddd119@",
                  "title" => "<span class=\"os-number\">33.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Homeostasis</span>",
                  "slug" => "33-3-homeostasis"
                },
                {
                  "id" => "ad757859-6533-5b83-8e37-6748106de4a1@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "33-key-terms"
                },
                {
                  "id" => "f529b6d0-8500-5e8e-99ee-8cfed4235fc5@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "33-chapter-summary"
                },
                {
                  "id" => "81adcedf-980e-5c5a-8462-2988194a8a3e@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "33-visual-connection-questions"
                },
                {
                  "id" => "6fc3702d-eaf7-51a6-9a00-5910288fd0c5@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "33-review-questions"
                },
                {
                  "id" => "c2db3d7a-a5ef-5cb2-a7b0-ffcc8954113a@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "33-critical-thinking-questions"
                }
              ],
              "slug" => "33-the-animal-body-basic-form-and-function"
            },
            {
              "id" => "208e39b4-e2b0-517b-a1a5-520a358d8506@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>34</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Animal Nutrition and the Digestive System</span>",
              "contents" => [
                {
                  "id" => "41fb680f-b781-4e9a-a393-76ca49c55ff9@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "34-introduction"
                },
                {
                  "id" => "39eb2d7f-4604-401d-a5ed-ca159c04cc80@",
                  "title" => "<span class=\"os-number\">34.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Digestive Systems</span>",
                  "slug" => "34-1-digestive-systems"
                },
                {
                  "id" => "717906af-34be-4e1d-917d-e0e24bfc0901@",
                  "title" => "<span class=\"os-number\">34.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Nutrition and Energy Production</span>",
                  "slug" => "34-2-nutrition-and-energy-production"
                },
                {
                  "id" => "f4dc9545-9398-417d-bb23-249fc9892cac@",
                  "title" => "<span class=\"os-number\">34.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Digestive System Processes</span>",
                  "slug" => "34-3-digestive-system-processes"
                },
                {
                  "id" => "d8bc0f62-79c7-4777-bf95-3d94eeca7a1a@",
                  "title" => "<span class=\"os-number\">34.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Digestive System Regulation</span>",
                  "slug" => "34-4-digestive-system-regulation"
                },
                {
                  "id" => "86c6f3d8-186c-5a07-b748-a6010223e033@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "34-key-terms"
                },
                {
                  "id" => "cfbb19e0-a194-5dbc-979d-0313c5e66193@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "34-chapter-summary"
                },
                {
                  "id" => "35640451-5dd6-5197-85f0-0de14a782981@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "34-visual-connection-questions"
                },
                {
                  "id" => "0ed38205-7c6e-594a-b21e-d4f7b21587b7@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "34-review-questions"
                },
                {
                  "id" => "99ba73d2-bb08-55d4-ab27-199d6fe81970@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "34-critical-thinking-questions"
                }
              ],
              "slug" => "34-animal-nutrition-and-the-digestive-system"
            },
            {
              "id" => "19708995-94b5-5dda-bc87-c145f437a17c@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>35</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">The Nervous System</span>",
              "contents" => [
                {
                  "id" => "6dfe867e-6b08-47f3-a5f1-6bce3259ecb4@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "35-introduction"
                },
                {
                  "id" => "73d8f8a7-46a3-4a3a-9afa-970f2f03deb3@",
                  "title" => "<span class=\"os-number\">35.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Neurons and Glial Cells</span>",
                  "slug" => "35-1-neurons-and-glial-cells"
                },
                {
                  "id" => "72cfcf6f-e196-4e0b-9bcf-45f4853993e4@",
                  "title" => "<span class=\"os-number\">35.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">How Neurons Communicate</span>",
                  "slug" => "35-2-how-neurons-communicate"
                },
                {
                  "id" => "24e8609c-16a7-4dd5-b3da-e38aaeef7ed5@",
                  "title" => "<span class=\"os-number\">35.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Central Nervous System</span>",
                  "slug" => "35-3-the-central-nervous-system"
                },
                {
                  "id" => "56a8c532-664f-4ad7-8edf-2305d723be10@",
                  "title" => "<span class=\"os-number\">35.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Peripheral Nervous System</span>",
                  "slug" => "35-4-the-peripheral-nervous-system"
                },
                {
                  "id" => "c1f66449-457f-401a-bac3-12c65da2779a@",
                  "title" => "<span class=\"os-number\">35.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Nervous System Disorders</span>",
                  "slug" => "35-5-nervous-system-disorders"
                },
                {
                  "id" => "74c94ca4-7be1-5358-92de-9308edb48fa6@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "35-key-terms"
                },
                {
                  "id" => "b71d4743-919f-50c0-8970-b2bf4c023f4e@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "35-chapter-summary"
                },
                {
                  "id" => "60a0cc0e-e2d7-525a-9483-a1495f163bb4@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "35-visual-connection-questions"
                },
                {
                  "id" => "36186e04-a1d8-50ad-a263-d46815a480a1@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "35-review-questions"
                },
                {
                  "id" => "9a9c74bd-5cfd-5ab5-bb66-6f5dc8ed7a75@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "35-critical-thinking-questions"
                }
              ],
              "slug" => "35-the-nervous-system"
            },
            {
              "id" => "6058c936-fd91-5dc5-9ca0-b26fa12eabd7@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>36</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Sensory Systems</span>",
              "contents" => [
                {
                  "id" => "bab1b85e-198a-4bb6-b801-c8d543f17f6e@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "36-introduction"
                },
                {
                  "id" => "e9f97e0d-10ae-43ec-9062-5f0079dfd57f@",
                  "title" => "<span class=\"os-number\">36.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Sensory Processes</span>",
                  "slug" => "36-1-sensory-processes"
                },
                {
                  "id" => "b32f61fc-5fab-4b07-bcc8-e455aa4a903d@",
                  "title" => "<span class=\"os-number\">36.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Somatosensation</span>",
                  "slug" => "36-2-somatosensation"
                },
                {
                  "id" => "e6739dc0-2ea2-41ef-af28-61c53e04dbb0@",
                  "title" => "<span class=\"os-number\">36.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Taste and Smell</span>",
                  "slug" => "36-3-taste-and-smell"
                },
                {
                  "id" => "45f94050-f136-4699-9779-b2953173b7bf@",
                  "title" => "<span class=\"os-number\">36.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Hearing and Vestibular Sensation</span>",
                  "slug" => "36-4-hearing-and-vestibular-sensation"
                },
                {
                  "id" => "7efc0079-6e04-4ea9-a39c-6551121b9dd1@",
                  "title" => "<span class=\"os-number\">36.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Vision</span>",
                  "slug" => "36-5-vision"
                },
                {
                  "id" => "eca674d2-1ab1-59f0-ae1f-a69e8f61a7b8@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "36-key-terms"
                },
                {
                  "id" => "3db12d48-1a8b-506a-ab96-0d580b4ecb1f@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "36-chapter-summary"
                },
                {
                  "id" => "e2336912-165b-50c1-afab-5f1fee402e5b@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "36-visual-connection-questions"
                },
                {
                  "id" => "01c4de43-7cb8-563e-90e2-415d1db69923@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "36-review-questions"
                },
                {
                  "id" => "236205fc-7340-55b0-a61d-6b261c33ed5a@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "36-critical-thinking-questions"
                }
              ],
              "slug" => "36-sensory-systems"
            },
            {
              "id" => "35cdf262-25ea-5075-bcbb-13d08cd03d11@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>37</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">The Endocrine System</span>",
              "contents" => [
                {
                  "id" => "44398b9a-c25b-4e06-9352-feeac13dfad4@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "37-introduction"
                },
                {
                  "id" => "9970356c-0383-482a-a13e-9e4fdbfc8917@",
                  "title" => "<span class=\"os-number\">37.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Types of Hormones</span>",
                  "slug" => "37-1-types-of-hormones"
                },
                {
                  "id" => "cbe4c6ff-348e-4383-ae66-f6fa19823b6c@",
                  "title" => "<span class=\"os-number\">37.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">How Hormones Work</span>",
                  "slug" => "37-2-how-hormones-work"
                },
                {
                  "id" => "a0d22048-c0b6-4b2b-abf1-1a3e61ada97d@",
                  "title" => "<span class=\"os-number\">37.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Regulation of Body Processes</span>",
                  "slug" => "37-3-regulation-of-body-processes"
                },
                {
                  "id" => "0e09d3f8-790c-42fe-acb3-a7020c1eebe4@",
                  "title" => "<span class=\"os-number\">37.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Regulation of Hormone Production</span>",
                  "slug" => "37-4-regulation-of-hormone-production"
                },
                {
                  "id" => "a708d3cb-ec37-4cbb-a945-e0b5fb0be2fa@",
                  "title" => "<span class=\"os-number\">37.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Endocrine Glands</span>",
                  "slug" => "37-5-endocrine-glands"
                },
                {
                  "id" => "726f4190-38db-525a-8028-5a3531e7e519@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "37-key-terms"
                },
                {
                  "id" => "92e76122-ee0e-5cb8-9933-9be29cee38de@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "37-chapter-summary"
                },
                {
                  "id" => "ddebfd15-8ee4-5b7f-a364-5c6a3ca1f768@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "37-visual-connection-questions"
                },
                {
                  "id" => "b8f003a7-3183-5b5f-88bb-ece669798938@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "37-review-questions"
                },
                {
                  "id" => "dcc04056-ff1b-530b-a184-a9240bcb7267@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "37-critical-thinking-questions"
                }
              ],
              "slug" => "37-the-endocrine-system"
            },
            {
              "id" => "45384a35-75ab-53bb-ad59-49a6cd4ef823@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>38</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">The Musculoskeletal System</span>",
              "contents" => [
                {
                  "id" => "58ed7aec-ef1b-4c9c-bb2c-8ef972188acb@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "38-introduction"
                },
                {
                  "id" => "b30d4eb7-6be4-4db2-b8c9-20256add53f5@",
                  "title" => "<span class=\"os-number\">38.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Types of Skeletal Systems</span>",
                  "slug" => "38-1-types-of-skeletal-systems"
                },
                {
                  "id" => "aa6ac9bb-ae22-47f2-8dbf-608fc90dd3b4@",
                  "title" => "<span class=\"os-number\">38.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Bone</span>",
                  "slug" => "38-2-bone"
                },
                {
                  "id" => "f3a5c924-6b1b-4d1b-b506-906b00da0be5@",
                  "title" => "<span class=\"os-number\">38.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Joints and Skeletal Movement</span>",
                  "slug" => "38-3-joints-and-skeletal-movement"
                },
                {
                  "id" => "b7c9b702-b46c-435e-bea3-eee85ed940b4@",
                  "title" => "<span class=\"os-number\">38.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Muscle Contraction and Locomotion</span>",
                  "slug" => "38-4-muscle-contraction-and-locomotion"
                },
                {
                  "id" => "9c68e54b-73e9-5b56-87c3-4f04298d09d1@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "38-key-terms"
                },
                {
                  "id" => "df9bb22e-57dc-5667-87c3-f0509dd4aca0@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "38-chapter-summary"
                },
                {
                  "id" => "28986633-e19d-5460-9a67-c692cbaea4ba@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "38-visual-connection-questions"
                },
                {
                  "id" => "0369bb70-ef91-5d0c-82a8-1cc31820f7cf@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "38-review-questions"
                },
                {
                  "id" => "285658d7-3115-5919-be25-9d5659ab9390@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "38-critical-thinking-questions"
                }
              ],
              "slug" => "38-the-musculoskeletal-system"
            },
            {
              "id" => "d9d92c86-c524-553b-b8b2-70290122d968@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>39</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">The Respiratory System</span>",
              "contents" => [
                {
                  "id" => "11c269b9-1f41-4e45-b6c6-b8dc7275b5f7@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "39-introduction"
                },
                {
                  "id" => "df9f91d1-b8aa-45f9-9d13-50913bf95614@",
                  "title" => "<span class=\"os-number\">39.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Systems of Gas Exchange</span>",
                  "slug" => "39-1-systems-of-gas-exchange"
                },
                {
                  "id" => "079215a1-b957-465f-bb1e-2393dcfe8915@",
                  "title" => "<span class=\"os-number\">39.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Gas Exchange across Respiratory Surfaces</span>",
                  "slug" => "39-2-gas-exchange-across-respiratory-surfaces"
                },
                {
                  "id" => "1388be61-0219-4b08-b6d6-b3c7396b5fa3@",
                  "title" => "<span class=\"os-number\">39.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Breathing</span>",
                  "slug" => "39-3-breathing"
                },
                {
                  "id" => "b241186c-4978-4904-ad7b-43e06974d549@",
                  "title" => "<span class=\"os-number\">39.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Transport of Gases in Human Bodily Fluids</span>",
                  "slug" => "39-4-transport-of-gases-in-human-bodily-fluids"
                },
                {
                  "id" => "e6627402-de0b-5323-a4c6-a4ea6d92e00c@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "39-key-terms"
                },
                {
                  "id" => "37460578-0bde-5fd4-b977-d8f2a5a4d0b1@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "39-chapter-summary"
                },
                {
                  "id" => "52b507e0-24c7-5470-be77-706719be7fa1@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "39-visual-connection-questions"
                },
                {
                  "id" => "c8cb6db3-b529-5405-a06d-6c03d5f8caaf@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "39-review-questions"
                },
                {
                  "id" => "4be4497b-0ea5-5dfe-844a-9c7ba07087d5@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "39-critical-thinking-questions"
                }
              ],
              "slug" => "39-the-respiratory-system"
            },
            {
              "id" => "01e098a7-b2e6-5b3d-90f8-a58e0a39f273@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>40</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">The Circulatory System</span>",
              "contents" => [
                {
                  "id" => "69577d07-ed4b-46ca-8f63-f99d08d0f8da@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "40-introduction"
                },
                {
                  "id" => "599f6b13-33a3-4c76-908d-03c0f998d143@",
                  "title" => "<span class=\"os-number\">40.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Overview of the Circulatory System</span>",
                  "slug" => "40-1-overview-of-the-circulatory-system"
                },
                {
                  "id" => "fd78a9c0-a232-4b11-b3a3-ab6955731177@",
                  "title" => "<span class=\"os-number\">40.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Components of the Blood</span>",
                  "slug" => "40-2-components-of-the-blood"
                },
                {
                  "id" => "65d0b611-6bb3-47ae-84c2-471fb52ba148@",
                  "title" => "<span class=\"os-number\">40.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Mammalian Heart and Blood Vessels</span>",
                  "slug" => "40-3-mammalian-heart-and-blood-vessels"
                },
                {
                  "id" => "607aff2b-b38c-47f2-8baa-b046cc7c6d85@",
                  "title" => "<span class=\"os-number\">40.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Blood Flow and Blood Pressure Regulation</span>",
                  "slug" => "40-4-blood-flow-and-blood-pressure-regulation"
                },
                {
                  "id" => "51255f27-74cd-5fc1-90aa-5a3631baff49@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "40-key-terms"
                },
                {
                  "id" => "65f42569-ce29-547a-84bb-1256cc880f0f@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "40-chapter-summary"
                },
                {
                  "id" => "6a68ee54-bf00-5745-af09-2b81bea9b62a@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "40-visual-connection-questions"
                },
                {
                  "id" => "ecc5fe50-36ff-5f5a-a57d-4326b6090296@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "40-review-questions"
                },
                {
                  "id" => "8e5bd5f7-3cbb-5d97-a139-33fa4b28ea3a@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "40-critical-thinking-questions"
                }
              ],
              "slug" => "40-the-circulatory-system"
            },
            {
              "id" => "08b73643-1fac-56c6-8bd5-1cbcf5bca795@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>41</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Osmotic Regulation and Excretion</span>",
              "contents" => [
                {
                  "id" => "80b07b39-b117-406c-aa18-d5f82ce7ed86@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "41-introduction"
                },
                {
                  "id" => "d9b33f1c-23c0-46d3-8606-be1df10ccb63@",
                  "title" => "<span class=\"os-number\">41.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Osmoregulation and Osmotic Balance</span>",
                  "slug" => "41-1-osmoregulation-and-osmotic-balance"
                },
                {
                  "id" => "3e2c416b-efb4-4386-a1ca-f18fb7b83ec5@",
                  "title" => "<span class=\"os-number\">41.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Kidneys and Osmoregulatory Organs</span>",
                  "slug" => "41-2-the-kidneys-and-osmoregulatory-organs"
                },
                {
                  "id" => "a91a79a8-fad7-4fd5-a500-8db68ae7ad8c@",
                  "title" => "<span class=\"os-number\">41.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Excretion Systems</span>",
                  "slug" => "41-3-excretion-systems"
                },
                {
                  "id" => "74427621-5991-4457-a80a-bc6b2edd4896@",
                  "title" => "<span class=\"os-number\">41.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Nitrogenous Wastes</span>",
                  "slug" => "41-4-nitrogenous-wastes"
                },
                {
                  "id" => "9e7345a6-ff4a-4839-b05c-8c3f580aa32c@",
                  "title" => "<span class=\"os-number\">41.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Hormonal Control of Osmoregulatory Functions</span>",
                  "slug" => "41-5-hormonal-control-of-osmoregulatory-functions"
                },
                {
                  "id" => "6c1dc811-9c56-5679-a6aa-7da9f9d3c4fc@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "41-key-terms"
                },
                {
                  "id" => "bc61b1cf-6073-5bcf-ba65-59f379ccf855@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "41-chapter-summary"
                },
                {
                  "id" => "8c2afce6-6ef5-5e80-9b84-36c5e6577581@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "41-visual-connection-questions"
                },
                {
                  "id" => "c240f0dc-b6c0-5ba1-bcf5-9b40e42ebde6@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "41-review-questions"
                },
                {
                  "id" => "2b32e3da-765c-5999-8996-2295e1081b54@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "41-critical-thinking-questions"
                }
              ],
              "slug" => "41-osmotic-regulation-and-excretion"
            },
            {
              "id" => "13a7cc26-ec56-5ca4-bcbd-aafdfa1ab70f@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>42</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">The Immune System</span>",
              "contents" => [
                {
                  "id" => "cefec3f8-777e-4951-9b70-abf9d346b923@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "42-introduction"
                },
                {
                  "id" => "5da10a86-3129-460c-b5b6-0a40c00b9969@",
                  "title" => "<span class=\"os-number\">42.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Innate Immune Response</span>",
                  "slug" => "42-1-innate-immune-response"
                },
                {
                  "id" => "7ad6686e-c53e-45bb-aaa2-15327dff8d3e@",
                  "title" => "<span class=\"os-number\">42.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Adaptive Immune Response</span>",
                  "slug" => "42-2-adaptive-immune-response"
                },
                {
                  "id" => "01be6158-869f-44d1-83ea-a2ce64d85ef1@",
                  "title" => "<span class=\"os-number\">42.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Antibodies</span>",
                  "slug" => "42-3-antibodies"
                },
                {
                  "id" => "da9ed27d-8460-4964-9344-40a7c3901d29@",
                  "title" => "<span class=\"os-number\">42.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Disruptions in the Immune System</span>",
                  "slug" => "42-4-disruptions-in-the-immune-system"
                },
                {
                  "id" => "a2d1f560-9449-5d61-8827-2efe0f4e8e96@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "42-key-terms"
                },
                {
                  "id" => "9e1f72dd-49b5-5921-8c62-a74fe2a67402@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "42-chapter-summary"
                },
                {
                  "id" => "3ca2d797-8789-53c8-8e68-1c85d584d274@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "42-visual-connection-questions"
                },
                {
                  "id" => "cb78cbcf-1435-5379-a5ae-e08f3d5e728c@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "42-review-questions"
                },
                {
                  "id" => "2699802c-4ac4-5162-8205-859602a5c746@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "42-critical-thinking-questions"
                }
              ],
              "slug" => "42-the-immune-system"
            },
            {
              "id" => "dd1eb3a0-928d-5888-995f-0b421f3866ee@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>43</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Animal Reproduction and Development</span>",
              "contents" => [
                {
                  "id" => "1fc80d68-43c6-4a05-91a5-b839efdf2fa1@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "43-introduction"
                },
                {
                  "id" => "3127134b-36a5-4489-adea-3cc50af1305a@",
                  "title" => "<span class=\"os-number\">43.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Reproduction Methods</span>",
                  "slug" => "43-1-reproduction-methods"
                },
                {
                  "id" => "9b69aa5d-16fa-4604-a26b-e92f9ecd9bc0@",
                  "title" => "<span class=\"os-number\">43.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Fertilization</span>",
                  "slug" => "43-2-fertilization"
                },
                {
                  "id" => "07f97982-30d2-425e-8a82-542e6fdd666e@",
                  "title" => "<span class=\"os-number\">43.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Human Reproductive Anatomy and Gametogenesis</span>",
                  "slug" => "43-3-human-reproductive-anatomy-and-gametogenesis"
                },
                {
                  "id" => "1daddd9c-5131-4979-a7d5-a8183fca0ad8@",
                  "title" => "<span class=\"os-number\">43.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Hormonal Control of Human Reproduction</span>",
                  "slug" => "43-4-hormonal-control-of-human-reproduction"
                },
                {
                  "id" => "3422a2b7-9dee-4e6b-93b5-3f1fc92e88b9@",
                  "title" => "<span class=\"os-number\">43.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Human Pregnancy and Birth</span>",
                  "slug" => "43-5-human-pregnancy-and-birth"
                },
                {
                  "id" => "c8105eac-93c4-43e8-83f1-54995429e8ca@",
                  "title" => "<span class=\"os-number\">43.6</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Fertilization and Early Embryonic Development</span>",
                  "slug" => "43-6-fertilization-and-early-embryonic-development"
                },
                {
                  "id" => "68ae7446-32b4-4cc7-89a7-4615dd20f3bd@",
                  "title" => "<span class=\"os-number\">43.7</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Organogenesis and Vertebrate Formation</span>",
                  "slug" => "43-7-organogenesis-and-vertebrate-formation"
                },
                {
                  "id" => "9d1f3882-962a-57ee-84d9-d9238ce72096@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "43-key-terms"
                },
                {
                  "id" => "e650800f-5f1e-5da9-83d6-5d60e3cb2479@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "43-chapter-summary"
                },
                {
                  "id" => "cdf0341c-427f-5e23-a8dc-280a0763f5a5@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "43-visual-connection-questions"
                },
                {
                  "id" => "70332a10-781f-5543-a253-efb3c6945cda@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "43-review-questions"
                },
                {
                  "id" => "0271cd1f-a656-51aa-abe6-a4e011b4cd24@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "43-critical-thinking-questions"
                }
              ],
              "slug" => "43-animal-reproduction-and-development"
            }
          ],
          "slug" => "7-unit-7-animal-structure-and-function"
        },
        {
          "id" => "c5d4dd8b-759b-55b8-9013-2295dc735cf3@e989ec3",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Unit </span>8</span>\n    <span class=\"os-divider\"> </span>\n    <span data-type=\"\" itemprop=\"\" class=\"os-text\">Unit 8. Ecology</span>",
          "contents" => [
            {
              "id" => "7af8043f-ff11-5b74-94b2-97c397bdebd9@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>44</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Ecology and the Biosphere</span>",
              "contents" => [
                {
                  "id" => "c49b257a-c9b1-4e3f-bc9b-a1b080801af3@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "44-introduction"
                },
                {
                  "id" => "10d9c46e-990f-4404-b7af-802b5b4e0fa6@",
                  "title" => "<span class=\"os-number\">44.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Scope of Ecology</span>",
                  "slug" => "44-1-the-scope-of-ecology"
                },
                {
                  "id" => "405e3804-5c8c-4f00-9dce-06b279ac4f53@",
                  "title" => "<span class=\"os-number\">44.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Biogeography</span>",
                  "slug" => "44-2-biogeography"
                },
                {
                  "id" => "cf87c2b7-d8ec-4cba-adba-6c30f5736f63@",
                  "title" => "<span class=\"os-number\">44.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Terrestrial Biomes</span>",
                  "slug" => "44-3-terrestrial-biomes"
                },
                {
                  "id" => "4552b33e-01c6-487b-81da-7f630a9a4298@",
                  "title" => "<span class=\"os-number\">44.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Aquatic Biomes</span>",
                  "slug" => "44-4-aquatic-biomes"
                },
                {
                  "id" => "a1fb54b1-a560-4093-b4fc-277409b3b43b@",
                  "title" => "<span class=\"os-number\">44.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Climate and the Effects of Global Climate Change</span>",
                  "slug" => "44-5-climate-and-the-effects-of-global-climate-change"
                },
                {
                  "id" => "a4e952ae-51a6-5160-bee2-333acfd2cabc@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "44-key-terms"
                },
                {
                  "id" => "3a0ca41e-15e0-5723-96b1-d2a874394a5a@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "44-chapter-summary"
                },
                {
                  "id" => "c2685be4-0044-502e-bc4d-b4b52f1ce8e4@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "44-visual-connection-questions"
                },
                {
                  "id" => "84644b0c-0585-5740-baff-925d66bec67f@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "44-review-questions"
                },
                {
                  "id" => "662505ac-136f-5a4c-b98a-6bb56ad18417@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "44-critical-thinking-questions"
                }
              ],
              "slug" => "44-ecology-and-the-biosphere"
            },
            {
              "id" => "3c186315-1bd7-5b21-b490-86582d6fadb4@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>45</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Population and Community Ecology</span>",
              "contents" => [
                {
                  "id" => "d193fe8a-8026-4c62-bee4-e977c6de7989@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "45-introduction"
                },
                {
                  "id" => "36b59ccb-df39-4ba6-85cc-52f3042c36ab@",
                  "title" => "<span class=\"os-number\">45.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Population Demography</span>",
                  "slug" => "45-1-population-demography"
                },
                {
                  "id" => "04046ffb-73f6-4ccf-815d-e94697bab6fd@",
                  "title" => "<span class=\"os-number\">45.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Life Histories and Natural Selection</span>",
                  "slug" => "45-2-life-histories-and-natural-selection"
                },
                {
                  "id" => "79ebaf1a-0e1a-4efb-9712-9bb41919a17d@",
                  "title" => "<span class=\"os-number\">45.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Environmental Limits to Population Growth</span>",
                  "slug" => "45-3-environmental-limits-to-population-growth"
                },
                {
                  "id" => "bd8d993b-f105-4122-80ef-83d1dcfacde2@",
                  "title" => "<span class=\"os-number\">45.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Population Dynamics and Regulation</span>",
                  "slug" => "45-4-population-dynamics-and-regulation"
                },
                {
                  "id" => "9bf55f5c-6f4b-40d8-bc99-873d021291c3@",
                  "title" => "<span class=\"os-number\">45.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Human Population Growth</span>",
                  "slug" => "45-5-human-population-growth"
                },
                {
                  "id" => "774c6097-22c3-4621-a29f-62bb9d77d47e@",
                  "title" => "<span class=\"os-number\">45.6</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Community Ecology</span>",
                  "slug" => "45-6-community-ecology"
                },
                {
                  "id" => "98dc9ab6-4f77-4f2e-85fb-c69c97c68649@",
                  "title" => "<span class=\"os-number\">45.7</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Behavioral Biology: Proximate and Ultimate Causes of Behavior</span>",
                  "slug" => "45-7-behavioral-biology-proximate-and-ultimate-causes-of-behavior"
                },
                {
                  "id" => "247d2d27-fc38-5dad-97e2-b7a74c1bda6f@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "45-key-terms"
                },
                {
                  "id" => "b50671fe-02f3-5ca8-a9e0-76490c6ab8ca@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "45-chapter-summary"
                },
                {
                  "id" => "33e10c6c-43f6-5aac-a51e-071256e6de18@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "45-visual-connection-questions"
                },
                {
                  "id" => "a307a4e9-9e3c-5e85-826e-b17919f18db8@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "45-review-questions"
                },
                {
                  "id" => "b4397d35-1610-5258-b1e8-1611f8baa95e@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "45-critical-thinking-questions"
                }
              ],
              "slug" => "45-population-and-community-ecology"
            },
            {
              "id" => "3a1f9699-3915-54df-b0d8-1b04d82447ca@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>46</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Ecosystems</span>",
              "contents" => [
                {
                  "id" => "76221989-258f-44ce-a9cd-77a3f8494bbc@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "46-introduction"
                },
                {
                  "id" => "5f31b7ed-13e0-4a64-93b2-d1bb73a3e022@",
                  "title" => "<span class=\"os-number\">46.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Ecology of Ecosystems</span>",
                  "slug" => "46-1-ecology-of-ecosystems"
                },
                {
                  "id" => "c96960a6-68ef-4834-b36d-2abc00a61619@",
                  "title" => "<span class=\"os-number\">46.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Energy Flow through Ecosystems</span>",
                  "slug" => "46-2-energy-flow-through-ecosystems"
                },
                {
                  "id" => "65d16444-425c-4f43-bc48-a3d0de0c2fbd@",
                  "title" => "<span class=\"os-number\">46.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Biogeochemical Cycles</span>",
                  "slug" => "46-3-biogeochemical-cycles"
                },
                {
                  "id" => "4fcd6c00-0b41-5da5-b269-c1bdb6461868@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "46-key-terms"
                },
                {
                  "id" => "4dbb2c67-e367-5ae0-830d-09846f2828c2@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "46-chapter-summary"
                },
                {
                  "id" => "bd988f77-9dfe-5229-a49c-9404238c4320@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "46-visual-connection-questions"
                },
                {
                  "id" => "f102796f-b295-52c0-b687-6990fa71d110@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "46-review-questions"
                },
                {
                  "id" => "c976813f-75fe-5542-a987-a8c276e71049@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "46-critical-thinking-questions"
                }
              ],
              "slug" => "46-ecosystems"
            },
            {
              "id" => "06ac604c-cf09-5630-b308-bcf9957cc68b@e989ec3",
              "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>47</span>\n    <span class=\"os-divider\"> </span>\n    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Conservation Biology and Biodiversity</span>",
              "contents" => [
                {
                  "id" => "c0d58dad-90b4-4861-a66e-c4d495949899@",
                  "title" => "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction</span>",
                  "slug" => "47-introduction"
                },
                {
                  "id" => "96f938e3-f5b1-46bc-9665-79d3a607d9e7@",
                  "title" => "<span class=\"os-number\">47.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Biodiversity Crisis</span>",
                  "slug" => "47-1-the-biodiversity-crisis"
                },
                {
                  "id" => "773fc1ea-e2b8-4f5e-ade9-9b17d5b1d2b6@",
                  "title" => "<span class=\"os-number\">47.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Importance of Biodiversity to Human Life</span>",
                  "slug" => "47-2-the-importance-of-biodiversity-to-human-life"
                },
                {
                  "id" => "ef12a7d2-c569-4f8b-833c-595454102c1a@",
                  "title" => "<span class=\"os-number\">47.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Threats to Biodiversity</span>",
                  "slug" => "47-3-threats-to-biodiversity"
                },
                {
                  "id" => "aaf2ab73-1c53-4518-9a03-63e238421f59@",
                  "title" => "<span class=\"os-number\">47.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Preserving Biodiversity</span>",
                  "slug" => "47-4-preserving-biodiversity"
                },
                {
                  "id" => "8d963c2c-9e87-568f-9e93-ce993cf259c1@e989ec3",
                  "title" => "<span class=\"os-text\">Key Terms</span>",
                  "slug" => "47-key-terms"
                },
                {
                  "id" => "a77ce661-9d9f-5b8b-b24a-904b0c83fdb1@e989ec3",
                  "title" => "<span class=\"os-text\">Chapter Summary</span>",
                  "slug" => "47-chapter-summary"
                },
                {
                  "id" => "4bde0015-fc2d-58c0-9cb7-cef1370124eb@e989ec3",
                  "title" => "<span class=\"os-text\">Visual Connection Questions</span>",
                  "slug" => "47-visual-connection-questions"
                },
                {
                  "id" => "b974a5d6-c5d3-5156-a570-52ce2ba90dca@e989ec3",
                  "title" => "<span class=\"os-text\">Review Questions</span>",
                  "slug" => "47-review-questions"
                },
                {
                  "id" => "15da5851-f60e-5f1e-818c-2f17d311ece3@e989ec3",
                  "title" => "<span class=\"os-text\">Critical Thinking Questions</span>",
                  "slug" => "47-critical-thinking-questions"
                }
              ],
              "slug" => "47-conservation-biology-and-biodiversity"
            }
          ],
          "slug" => "8-unit-8-ecology"
        },
        {
          "id" => "85876150-cd23-42ac-ab49-a6002a43a5c8@",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Appendix </span>A</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Periodic Table of Elements</span>",
          "slug" => "a-the-periodic-table-of-elements"
        },
        {
          "id" => "aebd6cfc-39e6-4b33-ad78-604d5de78dfd@",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Appendix </span>B</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Geological Time</span>",
          "slug" => "b-geological-time"
        },
        {
          "id" => "fa9fa6f3-941c-45b2-927b-4a0ae10b0e07@",
          "title" => "<span class=\"os-number\"><span class=\"os-part-text\">Appendix </span>C</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Measurements and the Metric System</span>",
          "slug" => "c-measurements-and-the-metric-system"
        },
        {
          "id" => "18af2ca7-7db8-5fd3-a47d-d9576fd5f984@e989ec3",
          "title" => "<span class=\"os-text\">Index</span>",
          "slug" => "index"
        }
      ]
    end
  end
end
