require 'vcr_helper'

RSpec.describe Api::V1::BooksController, type: :request, api: :true, version: :v1, vcr: VCR_OPTS do
  let(:user)       { FactoryBot.create :user, :agreed_to_terms }
  let(:user_token) { FactoryBot.create :doorkeeper_access_token, resource_owner_id: user.id }

  context '#index' do
    it 'returns a list of books in the latest archive version' do
      api_get api_books_url, user_token
      expect(response).to have_http_status(:ok)

      expect(JSON.parse body).to eq [
        {
          "uuid" => "02040312-72c8-441e-a685-20e9333f3e1d",
          "version" => "247752b",
          "title" => "Introduction Sociology 2e",
          "slug" => "introduction-sociology-2e"
        },
        {
          "uuid" => "02776133-d49d-49cb-bfaa-67c7f61b25a1",
          "version" => "eb2e29d",
          "title" => "Intermediate Algebra",
          "slug" => "intermediate-algebra"
        },
        {
          "uuid" => "031da8d3-b525-429c-80cf-6c8ed997733a",
          "version" => "1aa3e7a",
          "title" => "College Physics",
          "slug" => "college-physics"
        },
        {
          "uuid" => "052b8372-0c5e-4ff6-8fd3-326377e9e91f",
          "version" => "e1283a2",
          "title" => "Principles Finance",
          "slug" => "principles-finance"
        },
        {
          "uuid" => "0889907c-f0ef-496a-bcb8-2a5bb121717f",
          "version" => "eb2e29d",
          "title" => "Elementary Algebra",
          "slug" => "elementary-algebra"
        },
        {
          "uuid" => "13ac107a-f15f-49d2-97e8-60ab2e3b519c",
          "version" => "ebc5beb",
          "title" => "Algebra And Trigonometry",
          "slug" => "algebra-and-trigonometry"
        },
        {
          "uuid" => "14fb4ad7-39a1-4eee-ab6e-3ef2482e3e22",
          "version" => "ccce780",
          "title" => "Anatomy And Physiology",
          "slug" => "anatomy-and-physiology"
        },
        {
          "uuid" => "16ab5b96-4598-45f9-993c-b8d78d82b0c6",
          "version" => "0cd082f",
          "title" => "Fizyka Dla Szkół Wyższych Tom 2",
          "slug" => "fizyka-dla-szkół-wyższych-tom-2"
        },
        {
          "uuid" => "175c88b6-f89b-4eba-9514-bc45e2139a1d",
          "version" => "9281eb6",
          "title" => "Física Universitaria Volumen 1",
          "slug" => "física-universitaria-volumen-1"
        },
        {
          "uuid" => "185cbf87-c72e-48f5-b51e-f14f21b5eabd",
          "version" => "e989ec3",
          "title" => "Biology",
          "slug" => "biology"
        },
        {
          "uuid" => "1b4ee0ce-ee89-44fa-a5e7-a0db9f0c94b1",
          "version" => "be11438",
          "title" => "Introduction Intellectual Property",
          "slug" => "introduction-intellectual-property"
        },
        {
          "uuid" => "21b1d0df-a716-4205-8e86-0d0787b2c991",
          "version" => "da492e7",
          "title" => "Cálculo Volumen 3",
          "slug" => "cálculo-volumen-3"
        },
        {
          "uuid" => "2731eee8-0eb1-4d80-ae83-01b4af642ff6",
          "version" => "deb6e19",
          "title" => "Principles Marketing",
          "slug" => "principles-marketing"
        },
        {
          "uuid" => "27f59064-990e-48f1-b604-5188b9086c29",
          "version" => "a6dd6c5",
          "title" => "Principles Macroeconomics 2e",
          "slug" => "principles-macroeconomics-2e"
        },
        {
          "uuid" => "2d941ab9-ac5b-4eb8-b21c-965d36a4f296",
          "version" => "54660e7",
          "title" => "Organizational Behavior",
          "slug" => "organizational-behavior"
        },
        {
          "uuid" => "2e737be8-ea65-48c3-aa0a-9f35b4c6a966",
          "version" => "faae451",
          "title" => "Astronomy",
          "slug" => "astronomy"
        },
        {
          "uuid" => "2f805b43-bce4-4379-add2-4fbf46700e4c",
          "version" => "ba2f95c",
          "title" => "Pharmacology",
          "slug" => "pharmacology"
        },
        {
          "uuid" => "30189442-6998-4686-ac05-ed152b91b9de",
          "version" => "1d23970",
          "title" => "Introductory Statistics",
          "slug" => "introductory-statistics"
        },
        {
          "uuid" => "33076054-ec1d-4417-8824-ce354efe42d0",
          "version" => "444e84e",
          "title" => "Principles Macroeconomics Ap Courses",
          "slug" => "principles-macroeconomics-ap-courses"
        },
        {
          "uuid" => "3d2454dc-2735-4e24-a7e0-f89a79893699",
          "version" => "0e37690",
          "title" => "Workplace Software Skills",
          "slug" => "workplace-software-skills"
        },
        {
          "uuid" => "4061c832-098e-4b3c-a1d9-7eb593a2cb31",
          "version" => "444e84e",
          "title" => "Principles Macroeconomics",
          "slug" => "principles-macroeconomics"
        },
        {
          "uuid" => "4539ae23-1ccc-421e-9b25-843acbb6c4b0",
          "version" => "741a7af",
          "title" => "Chemistry Atoms First",
          "slug" => "chemistry-atoms-first"
        },
        {
          "uuid" => "462aa3f1-d65d-4cd9-a5ee-3214f95769b8",
          "version" => "9b2eeca",
          "title" => "Química 2ed",
          "slug" => "química-2ed"
        },
        {
          "uuid" => "464a3fba-68c1-426a-99f9-597e739dc911",
          "version" => "c71840e",
          "title" => "Business Law I Essentials",
          "slug" => "business-law-i-essentials"
        },
        {
          "uuid" => "4abf04bf-93a0-45c3-9cbc-2cefd46e68cc",
          "version" => "8993bfc",
          "title" => "Psychology",
          "slug" => "psychology"
        },
        {
          "uuid" => "4c34671f-b057-4918-8796-38ca1b2f4151",
          "version" => "d0e5fcf",
          "title" => "Principles Economics 3e",
          "slug" => "principles-economics-3e"
        },
        {
          "uuid" => "4e09771f-a8aa-40ce-9063-aa58cc24e77f",
          "version" => "9d3b8c4",
          "title" => "Introduction Business",
          "slug" => "introduction-business"
        },
        {
          "uuid" => "4eaa8f03-88a8-485a-a777-dd3602f6c13e",
          "version" => "0cd082f",
          "title" => "Fizyka Dla Szkół Wyższych Tom 1",
          "slug" => "fizyka-dla-szkół-wyższych-tom-1"
        },
        {
          "uuid" => "503d9717-0d3a-409f-893e-d25740d237dc",
          "version" => "964da1b",
          "title" => "Preparing For College Success",
          "slug" => "preparing-for-college-success"
        },
        {
          "uuid" => "507feb1e-cfff-4b54-bc07-d52636cecfe3",
          "version" => "ebc5beb",
          "title" => "College Algebra Coreq",
          "slug" => "college-algebra-coreq"
        },
        {
          "uuid" => "52f5163f-a7e1-4545-b0fa-8001df262ca9",
          "version" => "ea84f53",
          "title" => "Precálculo 2ed",
          "slug" => "precálculo-2ed"
        },
        {
          "uuid" => "5bcc0e59-7345-421d-8507-a1e4608685e8",
          "version" => "a7f9edc",
          "title" => "American Government",
          "slug" => "american-government"
        },
        {
          "uuid" => "5c09762c-b540-47d3-9541-dda1f44f16e5",
          "version" => "a6dd6c5",
          "title" => "Principles Microeconomics 2e",
          "slug" => "principles-microeconomics-2e"
        },
        {
          "uuid" => "62a49025-8cd8-407c-9cfb-c7eba55cf1c6",
          "version" => "964da1b",
          "title" => "College Success Concise",
          "slug" => "college-success-concise"
        },
        {
          "uuid" => "63229ab9-f9ed-4be4-9d2b-ad5035a02f72",
          "version" => "f67f1a2",
          "title" => "Maternal Newborn Nursing",
          "slug" => "maternal-newborn-nursing"
        },
        {
          "uuid" => "636cbfd9-4e37-4575-83ab-9dec9029ca4e",
          "version" => "a6dd6c5",
          "title" => "Principles Microeconomics Ap Courses 2e",
          "slug" => "principles-microeconomics-ap-courses-2e"
        },
        {
          "uuid" => "652f4496-b33e-4b0f-8c8c-a712da36c7a3",
          "version" => "f67f1a2",
          "title" => "Psychiatric Mental Health",
          "slug" => "psychiatric-mental-health"
        },
        {
          "uuid" => "685e3163-1032-4529-bb3a-f97a54407214",
          "version" => "dbe4cb6",
          "title" => "World History Volume 1",
          "slug" => "world-history-volume-1"
        },
        {
          "uuid" => "685e3163-1032-4529-bb3a-f97a54412704",
          "version" => "dbe4cb6",
          "title" => "World History Volume 2",
          "slug" => "world-history-volume-2"
        },
        {
          "uuid" => "69619d2b-68f0-44b0-b074-a9b2bf90b2c6",
          "version" => "444e84e",
          "title" => "Principles Economics",
          "slug" => "principles-economics"
        },
        {
          "uuid" => "728df0bb-e07f-489d-91e3-4734a5932f92",
          "version" => "0708931",
          "title" => "Psychologia",
          "slug" => "psychologia"
        },
        {
          "uuid" => "759181db-a886-4a98-8f5c-770a83a78832",
          "version" => "d0e5fcf",
          "title" => "Principles Microeconomics 3e",
          "slug" => "principles-microeconomics-3e"
        },
        {
          "uuid" => "75dc0490-e1d0-4c96-b05a-d59274e287cc",
          "version" => "f67f1a2",
          "title" => "Clinical Nursing Skills",
          "slug" => "clinical-nursing-skills"
        },
        {
          "uuid" => "7db4d55f-5c0e-4c05-8b72-841685444165",
          "version" => "ba2f95c",
          "title" => "Nutrition",
          "slug" => "nutrition"
        },
        {
          "uuid" => "8079f22f-c0a0-43ed-bb35-871d8d9743f3",
          "version" => "da492e7",
          "title" => "Cálculo Volumen 2",
          "slug" => "cálculo-volumen-2"
        },
        {
          "uuid" => "823ae3e1-57c4-44c5-b54a-310091040cf6",
          "version" => "dd262f0",
          "title" => "Makroekonomia Podstawy",
          "slug" => "makroekonomia-podstawy"
        },
        {
          "uuid" => "85abf193-2bd2-4908-8563-90b8a7ac8df6",
          "version" => "741a7af",
          "title" => "Chemistry",
          "slug" => "chemistry"
        },
        {
          "uuid" => "8635f0be-e734-4cd1-a10e-8063e5b863b6",
          "version" => "da492e7",
          "title" => "Cálculo Volumen 1",
          "slug" => "cálculo-volumen-1"
        },
        {
          "uuid" => "89060098-2918-4037-8ebe-d90622d7a6bf",
          "version" => "91f18d9",
          "title" => "Introduction Political Science",
          "slug" => "introduction-political-science"
        },
        {
          "uuid" => "8d04a686-d5e8-4798-a27d-c608e4d0e187",
          "version" => "1aa3e7a",
          "title" => "College Physics Ap Courses",
          "slug" => "college-physics-ap-courses"
        },
        {
          "uuid" => "8d08a72f-5463-4856-b05c-58b0d65f5e61",
          "version" => "4e7fc95",
          "title" => "Introduction Python Programming",
          "slug" => "introduction-python-programming"
        },
        {
          "uuid" => "9117cf8c-a8a3-4875-8361-9cb0f1fc9362",
          "version" => "a6dd6c5",
          "title" => "Principles Macroeconomics Ap Courses 2e",
          "slug" => "principles-macroeconomics-ap-courses-2e"
        },
        {
          "uuid" => "914ac66e-e1ec-486d-8a9c-97b0f7a99774",
          "version" => "21122d7",
          "title" => "Business Ethics",
          "slug" => "business-ethics"
        },
        {
          "uuid" => "920d1c8a-606c-4888-bfd4-d1ee27ce1795",
          "version" => "b8b74c6",
          "title" => "Principles Managerial Accounting",
          "slug" => "principles-managerial-accounting"
        },
        {
          "uuid" => "9331ec14-7ea7-4415-a8dd-ee34f0c5f9c4",
          "version" => "ba2f95c",
          "title" => "Population Health",
          "slug" => "population-health"
        },
        {
          "uuid" => "9702782f-fd50-4310-92ac-d29d39065419",
          "version" => "9b2eeca",
          "title" => "Química Comenzando átomos 2ed",
          "slug" => "química-comenzando-átomos-2ed"
        },
        {
          "uuid" => "9ab4ba6d-1e48-486d-a2de-38ae1617ca84",
          "version" => "b8b74c6",
          "title" => "Principles Financial Accounting",
          "slug" => "principles-financial-accounting"
        },
        {
          "uuid" => "9b08c294-057f-4201-9f48-5d6ad992740d",
          "version" => "ebc5beb",
          "title" => "College Algebra",
          "slug" => "college-algebra"
        },
        {
          "uuid" => "9d8df601-4f12-4ac1-8224-b450bf739e5f",
          "version" => "60ff1bb",
          "title" => "American Government 2e",
          "slug" => "american-government-2e"
        },
        {
          "uuid" => "aff0c733-b223-4dfb-aad6-297bd361bdcf",
          "version" => "d0e5fcf",
          "title" => "Principles Macroeconomics 3e",
          "slug" => "principles-macroeconomics-3e"
        },
        {
          "uuid" => "b56bb9e9-5eb8-48ef-9939-88b1b12ce22f",
          "version" => "1d23970",
          "title" => "Introductory Business Statistics",
          "slug" => "introductory-business-statistics"
        },
        {
          "uuid" => "b647a9b9-7631-45a1-a8e7-5acc3a44fc01",
          "version" => "9281eb6",
          "title" => "Física Universitaria Volumen 3",
          "slug" => "física-universitaria-volumen-3"
        },
        {
          "uuid" => "bb62933e-f20a-4ffc-90aa-97b36c296c3e",
          "version" => "0cd082f",
          "title" => "Fizyka Dla Szkół Wyższych Tom 3",
          "slug" => "fizyka-dla-szkół-wyższych-tom-3"
        },
        {
          "uuid" => "bc498e1f-efe9-43a0-8dea-d3569ad09a82",
          "version" => "a6dd6c5",
          "title" => "Principles Economics 2e",
          "slug" => "principles-economics-2e"
        },
        {
          "uuid" => "c3acb2ab-7d5c-45ad-b3cd-e59673fedd4e",
          "version" => "54660e7",
          "title" => "Principles Management",
          "slug" => "principles-management"
        },
        {
          "uuid" => "c9cbc0aa-3afa-448b-8048-3ca2e0ee2f6a",
          "version" => "8f6c5ff",
          "title" => "Mikroekonomia Podstawy",
          "slug" => "mikroekonomia-podstawy"
        },
        {
          "uuid" => "ca344e2d-6731-43cd-b851-a7b3aa0b37aa",
          "version" => "444e84e",
          "title" => "Principles Microeconomics Ap Courses",
          "slug" => "principles-microeconomics-ap-courses"
        },
        {
          "uuid" => "caa57dab-41c7-455e-bd6f-f443cda5519c",
          "version" => "eb2e29d",
          "title" => "Prealgebra",
          "slug" => "prealgebra"
        },
        {
          "uuid" => "da02605d-6d69-447c-a9b9-caf06dc4f413",
          "version" => "9281eb6",
          "title" => "Física Universitaria Volumen 2",
          "slug" => "física-universitaria-volumen-2"
        },
        {
          "uuid" => "e53d6c8b-fd9e-4a28-8930-c564ca6fd77d",
          "version" => "dc4550b",
          "title" => "Introducción Estadística",
          "slug" => "introducción-estadística"
        },
        {
          "uuid" => "e8668a14-9a7d-4d74-b58c-3681f8351224",
          "version" => "964da1b",
          "title" => "College Success",
          "slug" => "college-success"
        },
        {
          "uuid" => "ea2f225e-6063-41ca-bcd8-36482e15ef65",
          "version" => "444e84e",
          "title" => "Principles Microeconomics",
          "slug" => "principles-microeconomics"
        },
        {
          "uuid" => "ee7ce46b-0972-4b2c-bc6e-8998c785cd57",
          "version" => "aa32f33",
          "title" => "Writing Guide",
          "slug" => "writing-guide"
        },
        {
          "uuid" => "f346fe75-ae39-4d11-ad32-d80c03df58cb",
          "version" => "dc4550b",
          "title" => "Introducción Estadística Empresarial",
          "slug" => "introducción-estadística-empresarial"
        },
        {
          "uuid" => "fd53eae1-fa23-47c7-bb1b-972349835c3c",
          "version" => "ebc5beb",
          "title" => "Precalculus",
          "slug" => "precalculus"
        },
        {
          "uuid" => "fe58be6f-3b61-4e16-b3b6-db6924f0b2f2",
          "version" => "ec28045",
          "title" => "Introduction Philosophy",
          "slug" => "introduction-philosophy"
        },
        {
          "uuid" => "4fd99458-6fdf-49bc-8688-a6dc17a1268d",
          "version" => "6bc3d51",
          "title" => "Anatomy And Physiology 2e",
          "slug" => "anatomy-and-physiology-2e"
        },
        {
          "uuid" => "7fccc9cf-9b71-44f6-800b-f9457fd64335",
          "version" => "994b2c8",
          "title" => "Chemistry 2e",
          "slug" => "chemistry-2e"
        },
        {
          "uuid" => "d9b85ee6-c57f-4861-8208-5ddf261e9c5f",
          "version" => "994b2c8",
          "title" => "Chemistry Atoms First 2e",
          "slug" => "chemistry-atoms-first-2e"
        },
        {
          "uuid" => "cce64fde-f448-43b8-ae88-27705cceb0da",
          "version" => "d226864",
          "title" => "Physics",
          "slug" => "physics"
        },
        {
          "uuid" => "e42bd376-624b-4c0f-972f-e0c57998e765",
          "version" => "b575f67",
          "title" => "Microbiology",
          "slug" => "microbiology"
        },
        {
          "uuid" => "35d7cce2-48dd-4403-b6a5-e828cb5a17da",
          "version" => "848220c",
          "title" => "College Algebra 2e",
          "slug" => "college-algebra-2e"
        },
        {
          "uuid" => "f021395f-fd63-46cd-ab95-037c6f051730",
          "version" => "848220c",
          "title" => "Precalculus 2e",
          "slug" => "precalculus-2e"
        },
        {
          "uuid" => "eaefdaf1-bda0-4ada-a9fe-f1c065bfcc4e",
          "version" => "848220c",
          "title" => "Algebra And Trigonometry 2e",
          "slug" => "algebra-and-trigonometry-2e"
        },
        {
          "uuid" => "59024a63-2b1a-4631-94c5-ae275a77b587",
          "version" => "848220c",
          "title" => "College Algebra Corequisite Support 2e",
          "slug" => "college-algebra-corequisite-support-2e"
        },
        {
          "uuid" => "394a1101-fd8f-4875-84fa-55f15b06ba66",
          "version" => "2762445",
          "title" => "Statistics",
          "slug" => "statistics"
        },
        {
          "uuid" => "4c29f9e5-a53d-42c0-bdb5-091990527d79",
          "version" => "6de823b",
          "title" => "Astronomy 2e",
          "slug" => "astronomy-2e"
        },
        {
          "uuid" => "30e47181-f52c-4a91-9c11-33380c428268",
          "version" => "dd9a377",
          "title" => "American Government 3e",
          "slug" => "american-government-3e"
        },
        {
          "uuid" => "7a0f9770-1c44-4acd-9920-1cd9a99f2a1e",
          "version" => "aa8a43e",
          "title" => "University Physics Volume 2",
          "slug" => "university-physics-volume-2"
        },
        {
          "uuid" => "af275420-6050-4707-995c-57b9cc13c358",
          "version" => "aa8a43e",
          "title" => "University Physics Volume 3",
          "slug" => "university-physics-volume-3"
        },
        {
          "uuid" => "a31df062-930a-4f46-8953-605711e6d204",
          "version" => "4069e42",
          "title" => "College Physics 2e",
          "slug" => "college-physics-2e"
        },
        {
          "uuid" => "fc65697b-5a9e-4dfe-ac03-035129f7be28",
          "version" => "4069e42",
          "title" => "College Physics Ap Courses 2e",
          "slug" => "college-physics-ap-courses-2e"
        },
        {
          "uuid" => "c4b474e4-4e3b-4232-b35c-2c3535bfae73",
          "version" => "0132dbf",
          "title" => "Introductory Statistics 2e",
          "slug" => "introductory-statistics-2e"
        },
        {
          "uuid" => "547026cb-a330-4809-94bf-126be5f62381",
          "version" => "0132dbf",
          "title" => "Introductory Business Statistics 2e",
          "slug" => "introductory-business-statistics-2e"
        },
        {
          "uuid" => "d380510e-6145-4625-b19a-4fa68204b6b1",
          "version" => "9c67d18",
          "title" => "Entrepreneurship",
          "slug" => "entrepreneurship"
        },
        {
          "uuid" => "cf0085c6-528c-4101-ad26-19c612c5a2fa",
          "version" => "6cb07de",
          "title" => "Introduction Anthropology",
          "slug" => "introduction-anthropology"
        },
        {
          "uuid" => "8b89d172-2927-466f-8661-01abc7ccdba4",
          "version" => "50af43a",
          "title" => "Calculus Volume 1",
          "slug" => "calculus-volume-1"
        },
        {
          "uuid" => "1d39a348-071f-4537-85b6-c98912458c3c",
          "version" => "50af43a",
          "title" => "Calculus Volume 2",
          "slug" => "calculus-volume-2"
        },
        {
          "uuid" => "a31cd793-2162-4e9e-acb5-6e6bbd76a5fa",
          "version" => "50af43a",
          "title" => "Calculus Volume 3",
          "slug" => "calculus-volume-3"
        },
        {
          "uuid" => "7193a423-3ad7-4ac6-98dd-90c70e4724b7",
          "version" => "02cd091",
          "title" => "Contemporary Mathematics",
          "slug" => "contemporary-mathematics"
        },
        {
          "uuid" => "55931856-c627-418b-a56f-1dd0007683a8",
          "version" => "848e348",
          "title" => "Elementary Algebra 2e",
          "slug" => "elementary-algebra-2e"
        },
        {
          "uuid" => "4664c267-cd62-4a99-8b28-1cb9b3aee347",
          "version" => "848e348",
          "title" => "Intermediate Algebra 2e",
          "slug" => "intermediate-algebra-2e"
        },
        {
          "uuid" => "f0fa90be-fca8-43c9-9aad-715c0a2cee2b",
          "version" => "848e348",
          "title" => "Prealgebra 2e",
          "slug" => "prealgebra-2e"
        },
        {
          "uuid" => "6c2f7d1d-fbad-42e8-b977-9b903e6cb83b",
          "version" => "39f5ed7",
          "title" => "Organic Chemistry",
          "slug" => "organic-chemistry"
        },
        {
          "uuid" => "746f171e-0d6a-4ef2-b69d-367880872f4a",
          "version" => "29a2b97",
          "title" => "Introduction Sociology 3e",
          "slug" => "introduction-sociology-3e"
        },
        {
          "uuid" => "4738cffb-5d2b-49c0-8368-47cb6dafdaa6",
          "version" => "1d6b5cb",
          "title" => "Fundamentals Nursing",
          "slug" => "fundamentals-nursing"
        },
        {
          "uuid" => "03481f82-baf1-407d-9bac-e614dae0a694",
          "version" => "ec5acc9",
          "title" => "Lifespan Development",
          "slug" => "lifespan-development"
        },
        {
          "uuid" => "06aba565-9432-40f6-97ee-b8a361f118a8",
          "version" => "2fbf548",
          "title" => "Psychology 2e",
          "slug" => "psychology-2e"
        },
        {
          "uuid" => "a7ba2fb8-8925-4987-b182-5f4429d48daa",
          "version" => "38f1603",
          "title" => "Us History",
          "slug" => "us-history"
        },
        {
          "uuid" => "8d50a0af-948b-4204-a71d-4826cba765b8",
          "version" => "bd6d639",
          "title" => "Biology 2e",
          "slug" => "biology-2e"
        },
        {
          "uuid" => "b3c1e1d2-839c-42b0-a314-e119a8aafbdd",
          "version" => "bd6d639",
          "title" => "Concepts Biology",
          "slug" => "concepts-biology"
        },
        {
          "uuid" => "6c322e32-9fb0-4c4d-a1d7-20c95c5c7af2",
          "version" => "bd6d639",
          "title" => "Biology Ap Courses",
          "slug" => "biology-ap-courses"
        },
        {
          "uuid" => "d50f6e32-0fda-46ef-a362-9bd36ca7c97d",
          "version" => "aa8a43e",
          "title" => "University Physics Volume 1",
          "slug" => "university-physics-volume-1"
        },
        {
          "uuid" => "cede1974-4a2e-47e9-bf60-8ab91962bb1f",
          "version" => "2237a85",
          "title" => "Medical Surgical Nursing",
          "slug" => "medical-surgical-nursing"
        },
        {
          "uuid" => "834a50e2-a7ad-4f31-872e-16807cfe4f44",
          "version" => "a82c1f2",
          "title" => "Marketing Podstawy",
          "slug" => "marketing-podstawy"
        },
        {
          "uuid" => "4f06ce31-1d04-410f-8328-ac4e02c4f217",
          "version" => "111f5e5",
          "title" => "Introduction Computer Science",
          "slug" => "introduction-computer-science"
        },
        {
          "uuid" => "44175f46-f8f3-41e4-ab0d-35c454db6db8",
          "version" => "a9b3767",
          "title" => "Introduction Behavioral Neuroscience",
          "slug" => "introduction-behavioral-neuroscience"
        },
        {
          "uuid" => "54ef6090-af3e-47f9-8277-4a312aff4b2c",
          "version" => "4d02369",
          "title" => "Principles Data Science",
          "slug" => "principles-data-science"
        },
        {
          "uuid" => "372b4fed-e101-433d-9ba2-6ab71f087543",
          "version" => "d267c7d",
          "title" => "Foundations Information Systems",
          "slug" => "foundations-information-systems"
        },
        {
          "uuid" => "851baf99-d993-44bf-8b4d-5b0cadfe2445",
          "version" => "9fd7c2a",
          "title" => "Additive Manufacturing Essentials",
          "slug" => "additive-manufacturing-essentials"
        }
      ]
    end

    it 'returns a list of books in a given archive version' do
      api_get api_books_url(archive_version: '20210421.141058'), user_token
      expect(response).to have_http_status(:ok)

      expect(JSON.parse body).to eq [
        {
          "uuid" => "02040312-72c8-441e-a685-20e9333f3e1d",
          "version" => "247752b",
          "title" => "Introduction Sociology 2e",
          "slug" => "introduction-sociology-2e"
        },
        {
          "uuid" => "02776133-d49d-49cb-bfaa-67c7f61b25a1",
          "version" => "eb2e29d",
          "title" => "Intermediate Algebra",
          "slug" => "intermediate-algebra"
        },
        {
          "uuid" => "0889907c-f0ef-496a-bcb8-2a5bb121717f",
          "version" => "eb2e29d",
          "title" => "Elementary Algebra",
          "slug" => "elementary-algebra"
        },
        {
          "uuid" => "13ac107a-f15f-49d2-97e8-60ab2e3b519c",
          "version" => "ebc5beb",
          "title" => "Algebra And Trigonometry",
          "slug" => "algebra-and-trigonometry"
        },
        {
          "uuid" => "14fb4ad7-39a1-4eee-ab6e-3ef2482e3e22",
          "version" => "ccce780",
          "title" => "Anatomy And Physiology",
          "slug" => "anatomy-and-physiology"
        },
        {
          "uuid" => "16ab5b96-4598-45f9-993c-b8d78d82b0c6",
          "version" => "0cd082f",
          "title" => "Fizyka Dla Szkół Wyższych Tom 2",
          "slug" => "fizyka-dla-szkół-wyższych-tom-2"
        },
        {
          "uuid" => "185cbf87-c72e-48f5-b51e-f14f21b5eabd",
          "version" => "e989ec3",
          "title" => "Biology",
          "slug" => "biology"
        },
        {
          "uuid" => "1b4ee0ce-ee89-44fa-a5e7-a0db9f0c94b1",
          "version" => "be11438",
          "title" => "Introduction Intellectual Property",
          "slug" => "introduction-intellectual-property"
        },
        {
          "uuid" => "27f59064-990e-48f1-b604-5188b9086c29",
          "version" => "a6dd6c5",
          "title" => "Principles Macroeconomics 2e",
          "slug" => "principles-macroeconomics-2e"
        },
        {
          "uuid" => "2d941ab9-ac5b-4eb8-b21c-965d36a4f296",
          "version" => "54660e7",
          "title" => "Organizational Behavior",
          "slug" => "organizational-behavior"
        },
        {
          "uuid" => "2e737be8-ea65-48c3-aa0a-9f35b4c6a966",
          "version" => "faae451",
          "title" => "Astronomy",
          "slug" => "astronomy"
        },
        {
          "uuid" => "30189442-6998-4686-ac05-ed152b91b9de",
          "version" => "1d23970",
          "title" => "Introductory Statistics",
          "slug" => "introductory-statistics"
        },
        {
          "uuid" => "33076054-ec1d-4417-8824-ce354efe42d0",
          "version" => "444e84e",
          "title" => "Principles Macroeconomics Ap Courses",
          "slug" => "principles-macroeconomics-ap-courses"
        },
        {
          "uuid" => "4061c832-098e-4b3c-a1d9-7eb593a2cb31",
          "version" => "444e84e",
          "title" => "Principles Macroeconomics",
          "slug" => "principles-macroeconomics"
        },
        {
          "uuid" => "4539ae23-1ccc-421e-9b25-843acbb6c4b0",
          "version" => "741a7af",
          "title" => "Chemistry Atoms First",
          "slug" => "chemistry-atoms-first"
        },
        {
          "uuid" => "464a3fba-68c1-426a-99f9-597e739dc911",
          "version" => "c71840e",
          "title" => "Business Law I Essentials",
          "slug" => "business-law-i-essentials"
        },
        {
          "uuid" => "4abf04bf-93a0-45c3-9cbc-2cefd46e68cc",
          "version" => "8993bfc",
          "title" => "Psychology",
          "slug" => "psychology"
        },
        {
          "uuid" => "4e09771f-a8aa-40ce-9063-aa58cc24e77f",
          "version" => "9d3b8c4",
          "title" => "Introduction Business",
          "slug" => "introduction-business"
        },
        {
          "uuid" => "4eaa8f03-88a8-485a-a777-dd3602f6c13e",
          "version" => "0cd082f",
          "title" => "Fizyka Dla Szkół Wyższych Tom 1",
          "slug" => "fizyka-dla-szkół-wyższych-tom-1"
        },
        {
          "uuid" => "507feb1e-cfff-4b54-bc07-d52636cecfe3",
          "version" => "ebc5beb",
          "title" => "College Algebra Coreq",
          "slug" => "college-algebra-coreq"
        },
        {
          "uuid" => "5bcc0e59-7345-421d-8507-a1e4608685e8",
          "version" => "a7f9edc",
          "title" => "American Government",
          "slug" => "american-government"
        },
        {
          "uuid" => "5c09762c-b540-47d3-9541-dda1f44f16e5",
          "version" => "a6dd6c5",
          "title" => "Principles Microeconomics 2e",
          "slug" => "principles-microeconomics-2e"
        },
        {
          "uuid" => "636cbfd9-4e37-4575-83ab-9dec9029ca4e",
          "version" => "a6dd6c5",
          "title" => "Principles Microeconomics Ap Courses 2e",
          "slug" => "principles-microeconomics-ap-courses-2e"
        },
        {
          "uuid" => "69619d2b-68f0-44b0-b074-a9b2bf90b2c6",
          "version" => "444e84e",
          "title" => "Principles Economics",
          "slug" => "principles-economics"
        },
        {
          "uuid" => "728df0bb-e07f-489d-91e3-4734a5932f92",
          "version" => "0708931",
          "title" => "Psychologia",
          "slug" => "psychologia"
        },
        {
          "uuid" => "85abf193-2bd2-4908-8563-90b8a7ac8df6",
          "version" => "741a7af",
          "title" => "Chemistry",
          "slug" => "chemistry"
        },
        {
          "uuid" => "9117cf8c-a8a3-4875-8361-9cb0f1fc9362",
          "version" => "a6dd6c5",
          "title" => "Principles Macroeconomics Ap Courses 2e",
          "slug" => "principles-macroeconomics-ap-courses-2e"
        },
        {
          "uuid" => "914ac66e-e1ec-486d-8a9c-97b0f7a99774",
          "version" => "21122d7",
          "title" => "Business Ethics",
          "slug" => "business-ethics"
        },
        {
          "uuid" => "920d1c8a-606c-4888-bfd4-d1ee27ce1795",
          "version" => "b8b74c6",
          "title" => "Principles Managerial Accounting",
          "slug" => "principles-managerial-accounting"
        },
        {
          "uuid" => "9ab4ba6d-1e48-486d-a2de-38ae1617ca84",
          "version" => "b8b74c6",
          "title" => "Principles Financial Accounting",
          "slug" => "principles-financial-accounting"
        },
        {
          "uuid" => "9b08c294-057f-4201-9f48-5d6ad992740d",
          "version" => "ebc5beb",
          "title" => "College Algebra",
          "slug" => "college-algebra"
        },
        {
          "uuid" => "9d8df601-4f12-4ac1-8224-b450bf739e5f",
          "version" => "60ff1bb",
          "title" => "American Government 2e",
          "slug" => "american-government-2e"
        },
        {
          "uuid" => "b56bb9e9-5eb8-48ef-9939-88b1b12ce22f",
          "version" => "1d23970",
          "title" => "Introductory Business Statistics",
          "slug" => "introductory-business-statistics"
        },
        {
          "uuid" => "bb62933e-f20a-4ffc-90aa-97b36c296c3e",
          "version" => "0cd082f",
          "title" => "Fizyka Dla Szkół Wyższych Tom 3",
          "slug" => "fizyka-dla-szkół-wyższych-tom-3"
        },
        {
          "uuid" => "bc498e1f-efe9-43a0-8dea-d3569ad09a82",
          "version" => "a6dd6c5",
          "title" => "Principles Economics 2e",
          "slug" => "principles-economics-2e"
        },
        {
          "uuid" => "c3acb2ab-7d5c-45ad-b3cd-e59673fedd4e",
          "version" => "54660e7",
          "title" => "Principles Management",
          "slug" => "principles-management"
        },
        {
          "uuid" => "ca344e2d-6731-43cd-b851-a7b3aa0b37aa",
          "version" => "444e84e",
          "title" => "Principles Microeconomics Ap Courses",
          "slug" => "principles-microeconomics-ap-courses"
        },
        {
          "uuid" => "caa57dab-41c7-455e-bd6f-f443cda5519c",
          "version" => "eb2e29d",
          "title" => "Prealgebra",
          "slug" => "prealgebra"
        },
        {
          "uuid" => "ea2f225e-6063-41ca-bcd8-36482e15ef65",
          "version" => "444e84e",
          "title" => "Principles Microeconomics",
          "slug" => "principles-microeconomics"
        },
        {
          "uuid" => "fd53eae1-fa23-47c7-bb1b-972349835c3c",
          "version" => "ebc5beb",
          "title" => "Precalculus",
          "slug" => "precalculus"
        },
        {
          "uuid" => "cce64fde-f448-43b8-ae88-27705cceb0da",
          "version" => "d226864",
          "title" => "Physics",
          "slug" => "physics"
        },
        {
          "uuid" => "e42bd376-624b-4c0f-972f-e0c57998e765",
          "version" => "b575f67",
          "title" => "Microbiology",
          "slug" => "microbiology"
        },
        {
          "uuid" => "394a1101-fd8f-4875-84fa-55f15b06ba66",
          "version" => "2762445",
          "title" => "Statistics",
          "slug" => "statistics"
        },
        {
          "uuid" => "4c29f9e5-a53d-42c0-bdb5-091990527d79",
          "version" => "6de823b",
          "title" => "Astronomy 2e",
          "slug" => "astronomy-2e"
        },
        {
          "uuid" => "30e47181-f52c-4a91-9c11-33380c428268",
          "version" => "dd9a377",
          "title" => "American Government 3e",
          "slug" => "american-government-3e"
        },
        {
          "uuid" => "7a0f9770-1c44-4acd-9920-1cd9a99f2a1e",
          "version" => "aa8a43e",
          "title" => "University Physics Volume 2",
          "slug" => "university-physics-volume-2"
        },
        {
          "uuid" => "af275420-6050-4707-995c-57b9cc13c358",
          "version" => "aa8a43e",
          "title" => "University Physics Volume 3",
          "slug" => "university-physics-volume-3"
        },
        {
          "uuid" => "d380510e-6145-4625-b19a-4fa68204b6b1",
          "version" => "9c67d18",
          "title" => "Entrepreneurship",
          "slug" => "entrepreneurship"
        },
        {
          "uuid" => "8b89d172-2927-466f-8661-01abc7ccdba4",
          "version" => "50af43a",
          "title" => "Calculus Volume 1",
          "slug" => "calculus-volume-1"
        },
        {
          "uuid" => "1d39a348-071f-4537-85b6-c98912458c3c",
          "version" => "50af43a",
          "title" => "Calculus Volume 2",
          "slug" => "calculus-volume-2"
        },
        {
          "uuid" => "a31cd793-2162-4e9e-acb5-6e6bbd76a5fa",
          "version" => "50af43a",
          "title" => "Calculus Volume 3",
          "slug" => "calculus-volume-3"
        },
        {
          "uuid" => "55931856-c627-418b-a56f-1dd0007683a8",
          "version" => "848e348",
          "title" => "Elementary Algebra 2e",
          "slug" => "elementary-algebra-2e"
        },
        {
          "uuid" => "4664c267-cd62-4a99-8b28-1cb9b3aee347",
          "version" => "848e348",
          "title" => "Intermediate Algebra 2e",
          "slug" => "intermediate-algebra-2e"
        },
        {
          "uuid" => "f0fa90be-fca8-43c9-9aad-715c0a2cee2b",
          "version" => "848e348",
          "title" => "Prealgebra 2e",
          "slug" => "prealgebra-2e"
        },
        {
          "uuid" => "746f171e-0d6a-4ef2-b69d-367880872f4a",
          "version" => "29a2b97",
          "title" => "Introduction Sociology 3e",
          "slug" => "introduction-sociology-3e"
        },
        {
          "uuid" => "a7ba2fb8-8925-4987-b182-5f4429d48daa",
          "version" => "38f1603",
          "title" => "Us History",
          "slug" => "us-history"
        },
        {
          "uuid" => "8d50a0af-948b-4204-a71d-4826cba765b8",
          "version" => "bd6d639",
          "title" => "Biology 2e",
          "slug" => "biology-2e"
        },
        {
          "uuid" => "b3c1e1d2-839c-42b0-a314-e119a8aafbdd",
          "version" => "bd6d639",
          "title" => "Concepts Biology",
          "slug" => "concepts-biology"
        },
        {
          "uuid" => "6c322e32-9fb0-4c4d-a1d7-20c95c5c7af2",
          "version" => "bd6d639",
          "title" => "Biology Ap Courses",
          "slug" => "biology-ap-courses"
        },
        {
          "uuid" => "d50f6e32-0fda-46ef-a362-9bd36ca7c97d",
          "version" => "aa8a43e",
          "title" => "University Physics Volume 1",
          "slug" => "university-physics-volume-1"
        }
      ]
    end
  end

  context '#show' do
    it 'returns a list of pages in the latest book version' do
      api_get api_book_url(uuid: '02040312-72c8-441e-a685-20e9333f3e1d'), user_token
      expect(response).to have_http_status(:ok)

      expect(JSON.parse body).to eq [
        {
          "id" => "325e4afd-80b6-44dd-87b6-35aff4f40eac@",
          "title" =>
           "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Preface</span>",
          "toc_type" => "book-content",
          "toc_target_type" => "preface",
          "slug" => "preface"
        },
        {
          "id" => "795b15c3-7366-5a29-a985-54798220668d@247752b",
          "title" =>
           "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>1</span>\n" +
           "    <span class=\"os-divider\"> </span>\n" +
           "    <span class=\"os-text\" data-type=\"\" itemprop=\"\">An Introduction to Sociology</span>",
          "toc_type" => "chapter",
          "contents" => [
            {
              "id" => "4eb21133-cf0a-4ea7-81f5-b1e47698ec30@",
              "title" =>
               "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Sociology</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "intro",
              "slug" => "1-introduction-to-sociology"
            },
            {
              "id" => "5d97ba77-626b-4670-a1bb-c65fdd07bb0c@",
              "title" =>
               "<span class=\"os-number\">1.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">What Is Sociology?</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "1-1-what-is-sociology"
            },
            {
              "id" => "82966abb-ebb0-48ab-8576-a52a0e126bd9@",
              "title" =>
               "<span class=\"os-number\">1.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The History of Sociology</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "1-2-the-history-of-sociology"
            },
            {
              "id" => "40c45f23-6a75-414a-987a-cccd50bd04b8@",
              "title" =>
               "<span class=\"os-number\">1.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theoretical Perspectives</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "1-3-theoretical-perspectives"
            },
            {
              "id" => "2478dd75-fc23-48c8-9dfc-57a409d04c6b@",
              "title" =>
               "<span class=\"os-number\">1.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Why Study Sociology?</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "1-4-why-study-sociology"
            },
            {
              "id" => "13e975b8-eccc-55a8-b401-a3b43600dd24@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "1-key-terms"
            },
            {
              "id" => "2fd5c0d2-f29a-5919-b6f3-c098f794a9d1@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "1-section-summary"
            },
            {
              "id" => "caee6ed8-d0d7-57d2-9696-6a9c1c3a79e2@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "1-section-quiz"
            },
            {
              "id" => "2a7f9a21-f0d1-5513-9956-57d65efb10c7@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "1-short-answer"
            },
            {
              "id" => "c42480ad-12a1-5d9a-bb93-127b0efec627@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "1-further-research"
            },
            {
              "id" => "8348c301-f6bc-52e1-b610-2b6721532d87@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "1-references"
            }
          ],
          "slug" => "1-an-introduction-to-sociology"
        },
        {
          "id" => "1a4510e8-d047-5d5a-916f-37ae18a04b1d@247752b",
          "title" =>
           "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>2</span>\n" +
           "    <span class=\"os-divider\"> </span>\n" +
           "    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Sociological Research</span>",
          "toc_type" => "chapter",
          "contents" => [
            {
              "id" => "de329f8c-7690-4ea5-a3a4-d0ce6605d0ea@",
              "title" =>
               "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Sociological Research</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "intro",
              "slug" => "2-introduction-to-sociological-research"
            },
            {
              "id" => "baee4db6-1e28-43f9-a0b7-a4f3c7263598@",
              "title" =>
               "<span class=\"os-number\">2.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Approaches to Sociological Research</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "2-1-approaches-to-sociological-research"
            },
            {
              "id" => "e72e915a-719d-4496-ac15-5197a2c11258@",
              "title" =>
               "<span class=\"os-number\">2.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Research Methods</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "2-2-research-methods"
            },
            {
              "id" => "6d922c72-61cf-4f13-9b00-4f0c640cbf17@",
              "title" =>
               "<span class=\"os-number\">2.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Ethical Concerns</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "2-3-ethical-concerns"
            },
            {
              "id" => "0b68696a-c5d6-555a-b3aa-c0cfaee872cc@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "2-key-terms"
            },
            {
              "id" => "bae1ab4a-0967-5237-8ae3-d0a929f73337@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "2-section-summary"
            },
            {
              "id" => "eabe5ac5-3b18-531c-828f-cc6e28366464@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "2-section-quiz"
            },
            {
              "id" => "68020c4d-2398-543c-9924-c8dd64ff48ed@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "2-short-answer"
            },
            {
              "id" => "7d3e66c5-eaeb-5e95-a0f7-ad3a613e587a@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "2-further-research"
            },
            {
              "id" => "c8a34847-9909-535e-a6da-cf48bea2a411@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "2-references"
            }
          ],
          "slug" => "2-sociological-research"
        },
        {
          "id" => "c3aebdad-a315-5d48-ba72-22915a58b2cf@247752b",
          "title" =>
           "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>3</span>\n" +
           "    <span class=\"os-divider\"> </span>\n" +
           "    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Culture</span>",
          "toc_type" => "chapter",
          "contents" => [
            {
              "id" => "8a8ed60b-fb85-463f-a002-b48af257f894@",
              "title" =>
               "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Culture</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "intro",
              "slug" => "3-introduction-to-culture"
            },
            {
              "id" => "f87398b0-553a-4538-959d-15b28d0a80ef@",
              "title" =>
               "<span class=\"os-number\">3.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">What Is Culture?</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "3-1-what-is-culture"
            },
            {
              "id" => "f298104a-d0dd-432f-83ec-3881813a7eaa@",
              "title" =>
               "<span class=\"os-number\">3.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Elements of Culture</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "3-2-elements-of-culture"
            },
            {
              "id" => "4ee317f2-cc23-4075-b377-51ee4d11bb61@",
              "title" =>
               "<span class=\"os-number\">3.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Pop Culture, Subculture, and Cultural Change</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "3-3-pop-culture-subculture-and-cultural-change"
            },
            {
              "id" => "f2055c29-6b50-4a77-89d8-f88745ce0f18@",
              "title" =>
               "<span class=\"os-number\">3.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theoretical Perspectives on Culture</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "3-4-theoretical-perspectives-on-culture"
            },
            {
              "id" => "e18718ba-17ab-57bd-8adf-88d63018f4bd@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "3-key-terms"
            },
            {
              "id" => "1d6dd331-6952-5376-8972-38220ffdb61c@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "3-section-summary"
            },
            {
              "id" => "d39b2974-73b3-5e9b-8f2a-22877b408a81@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "3-section-quiz"
            },
            {
              "id" => "b87ddd05-92b5-5aef-8d08-5503a02b0abd@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "3-short-answer"
            },
            {
              "id" => "2f66caf6-a94f-528b-ab3f-04b716aa52d4@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "3-further-research"
            },
            {
              "id" => "196480ca-f09f-55fd-ad23-e6b46fd357a7@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "3-references"
            }
          ],
          "slug" => "3-culture"
        },
        {
          "id" => "1f473fa6-ce70-5e16-9e8e-5dea6aa68537@247752b",
          "title" =>
           "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>4</span>\n" +
           "    <span class=\"os-divider\"> </span>\n" +
           "    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Society and Social Interaction</span>",
          "toc_type" => "chapter",
          "contents" => [
            {
              "id" => "31eae3d7-1b57-4c24-ad0b-d08a2851b70d@",
              "title" =>
               "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Society and Social Interaction</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "intro",
              "slug" => "4-introduction-to-society-and-social-interaction"
            },
            {
              "id" => "aace8da1-b83e-4a5e-bfb8-5bd44699381a@",
              "title" =>
               "<span class=\"os-number\">4.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Types of Societies</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "4-1-types-of-societies"
            },
            {
              "id" => "6414e0c9-1e95-4b06-af38-b11762cb667e@",
              "title" =>
               "<span class=\"os-number\">4.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theoretical Perspectives on Society</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "4-2-theoretical-perspectives-on-society"
            },
            {
              "id" => "d06ad985-cecb-48b4-b222-197d04abc6a1@",
              "title" =>
               "<span class=\"os-number\">4.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Social Constructions of Reality</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "4-3-social-constructions-of-reality"
            },
            {
              "id" => "f3a073c2-5789-50f8-abfb-e5214c816bbd@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "4-key-terms"
            },
            {
              "id" => "e0f14b6d-4df2-5d69-b17a-25889f6ad2f7@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "4-section-summary"
            },
            {
              "id" => "038c8c7b-7161-5d23-8f14-cf3b8a808c65@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "4-section-quiz"
            },
            {
              "id" => "357b7a1c-af6e-501c-87c9-c47f48d86f66@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "4-short-answer"
            },
            {
              "id" => "aa893fc1-d064-5e30-9c7b-9296106faf21@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "4-further-research"
            },
            {
              "id" => "a38bc07c-fa38-5796-9277-62f01d15925b@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "4-references"
            }
          ],
          "slug" => "4-society-and-social-interaction"
        },
        {
          "id" => "c0ed45f6-7080-5331-882f-ca178047d6ac@247752b",
          "title" =>
           "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>5</span>\n" +
           "    <span class=\"os-divider\"> </span>\n" +
           "    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Socialization</span>",
          "toc_type" => "chapter",
          "contents" => [
            {
              "id" => "52eff48e-e18d-4231-9fe3-eb7ffb9ee365@",
              "title" =>
               "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Socialization</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "intro",
              "slug" => "5-introduction-to-socialization"
            },
            {
              "id" => "08e4a1f1-738c-4296-b07d-e13fa2973681@",
              "title" =>
               "<span class=\"os-number\">5.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theories of Self-Development</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "5-1-theories-of-self-development"
            },
            {
              "id" => "cde4e88d-3f69-4711-86d9-4f3b9697383b@",
              "title" =>
               "<span class=\"os-number\">5.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Why Socialization Matters</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "5-2-why-socialization-matters"
            },
            {
              "id" => "3256e44f-a765-4c3a-8728-3a6c92b49a65@",
              "title" =>
               "<span class=\"os-number\">5.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Agents of Socialization</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "5-3-agents-of-socialization"
            },
            {
              "id" => "269040ea-022f-40d1-b2f7-4b9219fa096d@",
              "title" =>
               "<span class=\"os-number\">5.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Socialization Across the Life Course</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "5-4-socialization-across-the-life-course"
            },
            {
              "id" => "07d1d306-3853-5c9d-b6d4-7ccfe3ee7a3d@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "5-key-terms"
            },
            {
              "id" => "d5d336d4-ebb9-5d70-a910-cdbbc7400cf7@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "5-section-summary"
            },
            {
              "id" => "6b6d5e1c-0c63-52cf-a7bc-e79c2f94dfb1@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "5-section-quiz"
            },
            {
              "id" => "32af6c6d-5b12-5218-a5e9-8bf8eb883b06@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "5-short-answer"
            },
            {
              "id" => "dcbec3a2-5246-5ea7-b99a-076f0ae94045@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "5-further-research"
            },
            {
              "id" => "24cb4487-b5c5-5afc-8296-fb7de89cc39c@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "5-references"
            }
          ],
          "slug" => "5-socialization"
        },
        {
          "id" => "291effe4-4e21-5933-85de-14f430f516ae@247752b",
          "title" =>
           "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>6</span>\n" +
           "    <span class=\"os-divider\"> </span>\n" +
           "    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Groups and Organization</span>",
          "toc_type" => "chapter",
          "contents" => [
            {
              "id" => "74c17c8b-542d-4b6d-81b8-1188530fd1c3@",
              "title" =>
               "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Groups and Organizations</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "intro",
              "slug" => "6-introduction-to-groups-and-organizations"
            },
            {
              "id" => "d95043f3-b879-4ad1-bd2c-7654f592c853@",
              "title" =>
               "<span class=\"os-number\">6.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Types of Groups</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "6-1-types-of-groups"
            },
            {
              "id" => "a2b20cc9-c475-4b89-bf51-03ed75861dca@",
              "title" =>
               "<span class=\"os-number\">6.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Group Size and Structure</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "6-2-group-size-and-structure"
            },
            {
              "id" => "aebb5e2c-a825-4192-a8c0-91678b449ec2@",
              "title" =>
               "<span class=\"os-number\">6.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Formal Organizations</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "6-3-formal-organizations"
            },
            {
              "id" => "895c4144-c266-5859-90fc-e72118450c58@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "6-key-terms"
            },
            {
              "id" => "559f7e2c-6dbb-57d2-b070-c2b2ff0329b5@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "6-section-summary"
            },
            {
              "id" => "ddad5b74-659b-5027-9e9a-61a10a3e7c12@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "6-section-quiz"
            },
            {
              "id" => "bd671f7f-19b9-5632-9e88-54b670385e46@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "6-short-answer"
            },
            {
              "id" => "7621e1be-0583-558d-8222-f2a5924f50b5@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "6-further-research"
            },
            {
              "id" => "96a98d9e-8afe-5029-a453-e7265f835255@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "6-references"
            }
          ],
          "slug" => "6-groups-and-organization"
        },
        {
          "id" => "5e82ce2f-19cb-55a3-9134-fa37757c8ef9@247752b",
          "title" =>
           "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>7</span>\n" +
           "    <span class=\"os-divider\"> </span>\n" +
           "    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Deviance, Crime, and Social Control</span>",
          "toc_type" => "chapter",
          "contents" => [
            {
              "id" => "178fcbde-9ec6-46de-812f-1a44ad5144a5@",
              "title" =>
               "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Deviance, Crime, and Social Control</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "intro",
              "slug" => "7-introduction-to-deviance-crime-and-social-control"
            },
            {
              "id" => "cef21f33-7a41-49c6-b129-1a4e20b2b64d@",
              "title" =>
               "<span class=\"os-number\">7.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Deviance and Control</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "7-1-deviance-and-control"
            },
            {
              "id" => "398ece58-90b3-4378-b774-f71e06bab8fe@",
              "title" =>
               "<span class=\"os-number\">7.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theoretical Perspectives on Deviance</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "7-2-theoretical-perspectives-on-deviance"
            },
            {
              "id" => "dbfef635-98d1-49e6-ad56-efa7b91f506f@",
              "title" =>
               "<span class=\"os-number\">7.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Crime and the Law</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "7-3-crime-and-the-law"
            },
            {
              "id" => "755fdfbf-5477-51bc-93ee-48b980aa0ff6@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "7-key-terms"
            },
            {
              "id" => "1dc48300-8875-5395-b80b-f205a684a496@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "7-section-summary"
            },
            {
              "id" => "caaf7ecf-64ba-5f93-ba9a-ff517eff8d60@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "7-section-quiz"
            },
            {
              "id" => "10c7e5fd-ac08-56be-ad6a-26c0f28f5e9e@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "7-short-answer"
            },
            {
              "id" => "595a4bb3-1f83-5077-b51e-b9f05283476d@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "7-further-research"
            },
            {
              "id" => "24cb04bf-fbcb-57c0-be0a-3c920af8a3e3@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "7-references"
            }
          ],
          "slug" => "7-deviance-crime-and-social-control"
        },
        {
          "id" => "9682b572-5a72-57ee-8740-28a9865c66a1@247752b",
          "title" =>
           "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>8</span>\n" +
           "    <span class=\"os-divider\"> </span>\n" +
           "    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Media and Technology</span>",
          "toc_type" => "chapter",
          "contents" => [
            {
              "id" => "022f74e4-8ebc-4232-b3f1-e052ee6ef711@",
              "title" =>
               "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Media and Technology</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "intro",
              "slug" => "8-introduction-to-media-and-technology"
            },
            {
              "id" => "ff98c048-3f87-453f-a5f9-fd962553166d@",
              "title" =>
               "<span class=\"os-number\">8.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Technology Today</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "8-1-technology-today"
            },
            {
              "id" => "fd4e4037-aa50-4849-8c69-0d7b80d3ef3c@",
              "title" =>
               "<span class=\"os-number\">8.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Media and Technology in Society</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "8-2-media-and-technology-in-society"
            },
            {
              "id" => "f8e4d21a-488f-491c-9e07-968a0b3e48ba@",
              "title" =>
               "<span class=\"os-number\">8.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Global Implications of Media and Technology</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "8-3-global-implications-of-media-and-technology"
            },
            {
              "id" => "62b3caf7-b83a-4ff1-bb52-953afc1a9b6d@",
              "title" =>
               "<span class=\"os-number\">8.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theoretical Perspectives on Media and Technology</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "8-4-theoretical-perspectives-on-media-and-technology"
            },
            {
              "id" => "6551d9c2-0c2f-572e-8c68-8f2ec1b59de0@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "8-key-terms"
            },
            {
              "id" => "ab275695-ee4d-56b0-86d3-a32f84e00d10@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "8-section-summary"
            },
            {
              "id" => "fd1031b4-bdb6-5ad5-a685-987022ef64b5@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "8-section-quiz"
            },
            {
              "id" => "0c59a8d5-8fe1-531f-9d07-1fb717097b5d@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "8-short-answer"
            },
            {
              "id" => "83f59f29-67c8-53dd-bf85-6b63bad1c501@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "8-further-research"
            },
            {
              "id" => "3a5335cb-a85c-5760-835e-3f10c211b46c@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "8-references"
            }
          ],
          "slug" => "8-media-and-technology"
        },
        {
          "id" => "d20d1523-5aca-5d38-93c4-a5f5cff975c7@247752b",
          "title" =>
           "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>9</span>\n" +
           "    <span class=\"os-divider\"> </span>\n" +
           "    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Social Stratification in the United States</span>",
          "toc_type" => "chapter",
          "contents" => [
            {
              "id" => "6e2fe486-093d-4e60-9ca3-1bbce5481b9c@",
              "title" =>
               "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Social Stratification in the United States</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "intro",
              "slug" => "9-introduction-to-social-stratification-in-the-united-states"
            },
            {
              "id" => "2d80e77e-9e52-4bed-bf58-312c1b662922@",
              "title" =>
               "<span class=\"os-number\">9.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">What Is Social Stratification?</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "9-1-what-is-social-stratification"
            },
            {
              "id" => "61a9f276-1bde-4cef-ba2d-040bae4f90a2@",
              "title" =>
               "<span class=\"os-number\">9.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Social Stratification and Mobility in the United States</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "9-2-social-stratification-and-mobility-in-the-united-states"
            },
            {
              "id" => "3f1c42b1-6494-47b1-9120-fa45b47f50b7@",
              "title" =>
               "<span class=\"os-number\">9.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Global Stratification and Inequality</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "9-3-global-stratification-and-inequality"
            },
            {
              "id" => "34faad00-f5b5-4d54-93ae-708adc6df1ca@",
              "title" =>
               "<span class=\"os-number\">9.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theoretical Perspectives on Social Stratification</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "9-4-theoretical-perspectives-on-social-stratification"
            },
            {
              "id" => "17d10f13-acbf-5da2-8b7d-92aa6469bb6a@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "9-key-terms"
            },
            {
              "id" => "44d8e9ae-6dda-5645-a222-061e91359b4a@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "9-section-summary"
            },
            {
              "id" => "475665ab-3866-533d-8da6-2ef0473239e1@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "9-section-quiz"
            },
            {
              "id" => "27f08dce-17be-5161-af7a-cf10eb895c1e@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "9-short-answer"
            },
            {
              "id" => "c53a68fd-ba3d-5995-b008-7241e365e793@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "9-further-research"
            },
            {
              "id" => "c0c7d447-82d7-5335-905b-a33a87277496@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "9-references"
            }
          ],
          "slug" => "9-social-stratification-in-the-united-states"
        },
        {
          "id" => "ab68f635-6c5a-56d6-9253-d3a2d93e9e72@247752b",
          "title" =>
           "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>10</span>\n" +
           "    <span class=\"os-divider\"> </span>\n" +
           "    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Global Inequality</span>",
          "toc_type" => "chapter",
          "contents" => [
            {
              "id" => "b6166e6a-8ffe-494c-a1f3-7e4acb668280@",
              "title" =>
               "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Global Inequality</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "intro",
              "slug" => "10-introduction-to-global-inequality"
            },
            {
              "id" => "ed308f6a-61dd-447b-b1b4-5118e7e25b22@",
              "title" =>
               "<span class=\"os-number\">10.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Global Stratification and Classification</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "10-1-global-stratification-and-classification"
            },
            {
              "id" => "d7c18fbb-e549-46da-aff4-68e60949d130@",
              "title" =>
               "<span class=\"os-number\">10.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Global Wealth and Poverty</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "10-2-global-wealth-and-poverty"
            },
            {
              "id" => "c9770cc1-8415-475d-b691-99b289598974@",
              "title" =>
               "<span class=\"os-number\">10.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theoretical Perspectives on Global Stratification</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "10-3-theoretical-perspectives-on-global-stratification"
            },
            {
              "id" => "4c4d8bbb-1444-57cf-ad74-babe95fb414d@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "10-key-terms"
            },
            {
              "id" => "17aa110c-a483-53d5-a65c-1c7a56aa28a8@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "10-section-summary"
            },
            {
              "id" => "927bd6e7-917c-5b94-b239-100d57909e99@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "10-section-quiz"
            },
            {
              "id" => "6ec0e754-cace-587e-8288-32587285a1be@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "10-short-answer"
            },
            {
              "id" => "8f759c99-2e79-59e4-b199-dce83572ee35@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "10-further-research"
            },
            {
              "id" => "a05f3d1e-e473-5ead-9b3b-3b4bf7fee919@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "10-references"
            }
          ],
          "slug" => "10-global-inequality"
        },
        {
          "id" => "05279e72-a6ae-538b-be85-1bc1cd6577e0@247752b",
          "title" =>
           "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>11</span>\n" +
           "    <span class=\"os-divider\"> </span>\n" +
           "    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Race and Ethnicity</span>",
          "toc_type" => "chapter",
          "contents" => [
            {
              "id" => "1f4db786-0c13-415a-a456-ab07a24b2dfb@",
              "title" =>
               "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Race and Ethnicity</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "intro",
              "slug" => "11-introduction-to-race-and-ethnicity"
            },
            {
              "id" => "a55ca711-352c-47cb-ba17-35b00eb1f18a@",
              "title" =>
               "<span class=\"os-number\">11.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Racial, Ethnic, and Minority Groups</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "11-1-racial-ethnic-and-minority-groups"
            },
            {
              "id" => "d310a908-eb93-4b62-881a-12864fbb7157@",
              "title" =>
               "<span class=\"os-number\">11.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Stereotypes, Prejudice, and Discrimination</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "11-2-stereotypes-prejudice-and-discrimination"
            },
            {
              "id" => "b1afff9f-c485-4245-8ca2-30de4666d03b@",
              "title" =>
               "<span class=\"os-number\">11.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theories of Race and Ethnicity</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "11-3-theories-of-race-and-ethnicity"
            },
            {
              "id" => "134db5ed-6e53-42da-b821-6347b7b2554d@",
              "title" =>
               "<span class=\"os-number\">11.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Intergroup Relationships</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "11-4-intergroup-relationships"
            },
            {
              "id" => "b3cb90e7-b5d7-4e9c-91fc-e4fa2887f971@",
              "title" =>
               "<span class=\"os-number\">11.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Race and Ethnicity in the United States</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "11-5-race-and-ethnicity-in-the-united-states"
            },
            {
              "id" => "fe09c141-01dd-5590-9188-69ef5a5e17a5@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "11-key-terms"
            },
            {
              "id" => "c29e75a0-a50d-58eb-be4f-5488b0cc9c1f@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "11-section-summary"
            },
            {
              "id" => "652bb24f-73ef-5e07-9f08-ede1abd98fde@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "11-section-quiz"
            },
            {
              "id" => "57468a5b-6a7c-5d2c-a5ef-1d28dbe3d603@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "11-short-answer"
            },
            {
              "id" => "9b0eaf7f-6cce-597d-8af9-419c6b08ad02@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "11-further-research"
            },
            {
              "id" => "a26e7402-1fbb-5dd7-bb56-ce27a090f187@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "11-references"
            }
          ],
          "slug" => "11-race-and-ethnicity"
        },
        {
          "id" => "38cac246-2881-5863-8ed3-24ece737993e@247752b",
          "title" =>
           "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>12</span>\n" +
           "    <span class=\"os-divider\"> </span>\n" +
           "    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Gender, Sex, and Sexuality</span>",
          "toc_type" => "chapter",
          "contents" => [
            {
              "id" => "4fff8b4d-65dd-4c21-9dc2-d33bfc9ae1c0@",
              "title" =>
               "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Gender, Sex, and Sexuality</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "intro",
              "slug" => "12-introduction-to-gender-sex-and-sexuality"
            },
            {
              "id" => "26f66ec2-2527-441d-97a2-5e2d170cfc57@",
              "title" =>
               "<span class=\"os-number\">12.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Sex and Gender</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "12-1-sex-and-gender"
            },
            {
              "id" => "2138442f-2ad7-4ec3-9972-fc913805b42a@",
              "title" =>
               "<span class=\"os-number\">12.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Gender</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "12-2-gender"
            },
            {
              "id" => "672dd126-9ce3-4175-9db3-5bff44be91fe@",
              "title" =>
               "<span class=\"os-number\">12.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Sex and Sexuality</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "12-3-sex-and-sexuality"
            },
            {
              "id" => "d34f3e2f-e282-5faa-a4be-63a2b306dba0@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "12-key-terms"
            },
            {
              "id" => "d96d8526-4525-5b3e-946a-39b91009daf6@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "12-section-summary"
            },
            {
              "id" => "eae055b5-6e99-5ac3-a5c2-ad0d4872a68f@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "12-section-quiz"
            },
            {
              "id" => "5d83af92-2759-528f-90c4-e7ccfd9b2df7@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "12-short-answer"
            },
            {
              "id" => "2187aff8-22e6-5b9a-9853-0a4e6d1184c9@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "12-further-research"
            },
            {
              "id" => "f7104d28-024c-5890-af2a-308f84aac6f9@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "12-references"
            }
          ],
          "slug" => "12-gender-sex-and-sexuality"
        },
        {
          "id" => "d9be7457-30a3-5811-ac28-c5af83f9f32f@247752b",
          "title" =>
           "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>13</span>\n" +
           "    <span class=\"os-divider\"> </span>\n" +
           "    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Aging and the Elderly</span>",
          "toc_type" => "chapter",
          "contents" => [
            {
              "id" => "acdddf86-67ea-453a-861f-efb0a4b50202@",
              "title" =>
               "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Aging and the Elderly</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "intro",
              "slug" => "13-introduction-to-aging-and-the-elderly"
            },
            {
              "id" => "f4ce6106-f567-43a2-bcd9-f29ac6d7ea7c@",
              "title" =>
               "<span class=\"os-number\">13.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Who Are the Elderly? Aging in Society</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "13-1-who-are-the-elderly-aging-in-society"
            },
            {
              "id" => "d9df5e48-4b72-482e-b616-886926188054@",
              "title" =>
               "<span class=\"os-number\">13.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Process of Aging</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "13-2-the-process-of-aging"
            },
            {
              "id" => "a1ccdea8-6ff8-40ea-adc4-38bab44d04ee@",
              "title" =>
               "<span class=\"os-number\">13.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Challenges Facing the Elderly</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "13-3-challenges-facing-the-elderly"
            },
            {
              "id" => "ade7fd74-8340-4c21-a537-7d4c8d67d965@",
              "title" =>
               "<span class=\"os-number\">13.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theoretical Perspectives on Aging</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "13-4-theoretical-perspectives-on-aging"
            },
            {
              "id" => "76e10f79-f412-59b1-bbb7-599cf2c5d6ea@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "13-key-terms"
            },
            {
              "id" => "80faa867-d749-570f-993d-b5c7881f659d@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "13-section-summary"
            },
            {
              "id" => "8af16f1e-4a33-5dfa-8e7d-d43735eafdb7@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "13-section-quiz"
            },
            {
              "id" => "4c3c8a4f-b5de-590b-b556-cfe6dbb53698@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "13-short-answer"
            },
            {
              "id" => "3968d24e-3260-52b3-bbed-ad6293cca527@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "13-further-research"
            },
            {
              "id" => "041738c8-d345-5e40-a352-0f08c9943a7b@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "13-references"
            }
          ],
          "slug" => "13-aging-and-the-elderly"
        },
        {
          "id" => "021eb180-bb49-50f9-976a-02e8e36f9f35@247752b",
          "title" =>
           "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>14</span>\n" +
           "    <span class=\"os-divider\"> </span>\n" +
           "    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Marriage and Family</span>",
          "toc_type" => "chapter",
          "contents" => [
            {
              "id" => "f05f32bf-ca44-4bcf-80c1-9377fb1d21f7@",
              "title" =>
               "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Marriage and Family</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "intro",
              "slug" => "14-introduction-to-marriage-and-family"
            },
            {
              "id" => "fc2d2208-0a60-425e-9217-0d6ee659be7e@",
              "title" =>
               "<span class=\"os-number\">14.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">What Is Marriage? What Is a Family?</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "14-1-what-is-marriage-what-is-a-family"
            },
            {
              "id" => "fc504354-e135-4a28-b22a-2054dea6e315@",
              "title" =>
               "<span class=\"os-number\">14.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Variations in Family Life</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "14-2-variations-in-family-life"
            },
            {
              "id" => "5f441b6a-ae68-4d84-a106-1d1b011f0331@",
              "title" =>
               "<span class=\"os-number\">14.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Challenges Families Face</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "14-3-challenges-families-face"
            },
            {
              "id" => "5357eb1a-295e-535d-b7a7-4480557272e3@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "14-key-terms"
            },
            {
              "id" => "0576761e-98b8-547b-93b8-ef1aa119c3f0@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "14-section-summary"
            },
            {
              "id" => "c50a2095-d61d-53f4-bad7-8209f1322bf1@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "14-section-quiz"
            },
            {
              "id" => "bfee28a0-f52a-565c-91c9-a0bb17130c7d@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "14-short-answer"
            },
            {
              "id" => "4d2104b1-81c7-5a2a-907f-590eaf48c4cf@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "14-further-research"
            },
            {
              "id" => "829a290f-de59-5b7e-9d78-ca20353fb33b@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "14-references"
            }
          ],
          "slug" => "14-marriage-and-family"
        },
        {
          "id" => "7c429978-bf11-51d0-907a-a4477d9bf3db@247752b",
          "title" =>
           "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>15</span>\n" +
           "    <span class=\"os-divider\"> </span>\n" +
           "    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Religion</span>",
          "toc_type" => "chapter",
          "contents" => [
            {
              "id" => "a7255255-e4f0-472c-81c0-54ab97cb2e68@",
              "title" =>
               "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Religion</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "intro",
              "slug" => "15-introduction-to-religion"
            },
            {
              "id" => "53d3be59-277f-4139-b821-d04960c33d0b@",
              "title" =>
               "<span class=\"os-number\">15.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Sociological Approach to Religion</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "15-1-the-sociological-approach-to-religion"
            },
            {
              "id" => "93ebe6b3-6e50-4dc1-9bc0-a55f6935bccb@",
              "title" =>
               "<span class=\"os-number\">15.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">World Religions</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "15-2-world-religions"
            },
            {
              "id" => "5def2064-5c90-44ae-a963-6ecff5b80975@",
              "title" =>
               "<span class=\"os-number\">15.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Religion in the United States</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "15-3-religion-in-the-united-states"
            },
            {
              "id" => "fc0df951-64ba-5c34-9e8e-fea5d1f18a95@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "15-key-terms"
            },
            {
              "id" => "2fd07a19-bdf8-5896-9edd-a53ae70eeebc@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "15-section-summary"
            },
            {
              "id" => "5d03ae96-42d3-5f27-b5fc-5d410b33f042@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "15-section-quiz"
            },
            {
              "id" => "16c7c794-e94f-594a-90ab-90d181e6a74d@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "15-short-answer"
            },
            {
              "id" => "8a45358a-8782-5283-bf97-0648fa051ab3@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "15-further-research"
            },
            {
              "id" => "a6d4f5bb-2647-596b-ae15-29fb3f95e55e@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "15-references"
            }
          ],
          "slug" => "15-religion"
        },
        {
          "id" => "760fb7ef-98ac-5f22-934f-cbd52d96e799@247752b",
          "title" =>
           "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>16</span>\n" +
           "    <span class=\"os-divider\"> </span>\n" +
           "    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Education</span>",
          "toc_type" => "chapter",
          "contents" => [
            {
              "id" => "443cd6b3-64bc-4803-bd6a-eb216790a130@",
              "title" =>
               "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Education</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "intro",
              "slug" => "16-introduction-to-education"
            },
            {
              "id" => "55daa5bc-71b0-4578-8fec-51e39b581abd@",
              "title" =>
               "<span class=\"os-number\">16.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Education around the World</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "16-1-education-around-the-world"
            },
            {
              "id" => "43b4a12e-66b6-479a-935d-f5e568a10463@",
              "title" =>
               "<span class=\"os-number\">16.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theoretical Perspectives on Education</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "16-2-theoretical-perspectives-on-education"
            },
            {
              "id" => "984be05e-c3eb-422d-9170-47b1f0d02c9c@",
              "title" =>
               "<span class=\"os-number\">16.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Issues in Education</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "16-3-issues-in-education"
            },
            {
              "id" => "274c4c62-bba8-538d-8430-544f3384e585@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "16-key-terms"
            },
            {
              "id" => "63d49d09-a0ce-5dca-8241-6bbc6f43fb05@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "16-section-summary"
            },
            {
              "id" => "50c15692-1e97-506f-8ee0-0531c41873f4@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "16-section-quiz"
            },
            {
              "id" => "dfd829bf-f7a4-5e98-8026-5c74636cb95c@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "16-short-answer"
            },
            {
              "id" => "2cf3f92d-299a-51a3-b8f3-39ef0cf2b380@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "16-further-research"
            },
            {
              "id" => "9f082306-fe4b-59bf-b747-abf39b3783d3@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "16-references"
            }
          ],
          "slug" => "16-education"
        },
        {
          "id" => "fd3ea0f6-1992-52e7-bc51-f239002a5429@247752b",
          "title" =>
           "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>17</span>\n" +
           "    <span class=\"os-divider\"> </span>\n" +
           "    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Government and Politics</span>",
          "toc_type" => "chapter",
          "contents" => [
            {
              "id" => "75703577-ab2a-4b1d-860f-94514729c298@",
              "title" =>
               "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Government and Politics</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "intro",
              "slug" => "17-introduction-to-government-and-politics"
            },
            {
              "id" => "1af78294-fbeb-49fe-b2cf-fd747f5a3e2e@",
              "title" =>
               "<span class=\"os-number\">17.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Power and Authority</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "17-1-power-and-authority"
            },
            {
              "id" => "bf6698dd-c4d7-4559-82b2-3915859e3d75@",
              "title" =>
               "<span class=\"os-number\">17.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Forms of Government</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "17-2-forms-of-government"
            },
            {
              "id" => "1c4bead3-4898-4fe9-b5f9-fb91e8a00c3a@",
              "title" =>
               "<span class=\"os-number\">17.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Politics in the United States</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "17-3-politics-in-the-united-states"
            },
            {
              "id" => "940de604-e01b-4565-81df-78985b79919a@",
              "title" =>
               "<span class=\"os-number\">17.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theoretical Perspectives on Government and Power</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "17-4-theoretical-perspectives-on-government-and-power"
            },
            {
              "id" => "5675bf85-db89-5491-930a-d74314e236d6@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "17-key-terms"
            },
            {
              "id" => "1ba33a0d-26cd-511e-a017-3bd91f13a2cd@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "17-section-summary"
            },
            {
              "id" => "2e8e15a5-3349-5135-b51f-8f7e594d0590@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "17-section-quiz"
            },
            {
              "id" => "ce3f1ab2-861a-5032-9aca-efed828c69c1@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "17-short-answer"
            },
            {
              "id" => "85809e34-cda8-556a-be26-0bf61a352927@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "17-further-research"
            },
            {
              "id" => "d2cda32c-5912-5ae2-9ae1-e33464393095@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "17-references"
            }
          ],
          "slug" => "17-government-and-politics"
        },
        {
          "id" => "6a0430fe-03d6-5ff8-89bb-ac7ae445f2ac@247752b",
          "title" =>
           "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>18</span>\n" +
           "    <span class=\"os-divider\"> </span>\n" +
           "    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Work and the Economy</span>",
          "toc_type" => "chapter",
          "contents" => [
            {
              "id" => "6bde5892-e610-4f5f-bfbb-84f624ace8c6@",
              "title" =>
               "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Work and the Economy</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "intro",
              "slug" => "18-introduction-to-work-and-the-economy"
            },
            {
              "id" => "36f9cf93-9c5d-41f1-8c14-d7c89fea9b85@",
              "title" =>
               "<span class=\"os-number\">18.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Economic Systems</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "18-1-economic-systems"
            },
            {
              "id" => "5fe19034-9a53-44c7-bdc5-346d0d0753dc@",
              "title" =>
               "<span class=\"os-number\">18.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Globalization and the Economy</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "18-2-globalization-and-the-economy"
            },
            {
              "id" => "71d09a20-73f5-4265-9bae-7c5bc70a0a47@",
              "title" =>
               "<span class=\"os-number\">18.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Work in the United States</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "18-3-work-in-the-united-states"
            },
            {
              "id" => "cd538d9e-7dd9-5766-97ac-0d77e5dd6b06@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "18-key-terms"
            },
            {
              "id" => "76636eed-80a1-5ad6-acc4-0282db887f1a@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "18-section-summary"
            },
            {
              "id" => "8e7c57da-459b-523b-9257-6341e874c217@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "18-section-quiz"
            },
            {
              "id" => "f14b1e01-a3b0-59ce-81ee-9e623af69d21@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "18-short-answer"
            },
            {
              "id" => "f6f63364-a74d-5d57-96e5-66e6f7ebdaae@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "18-further-research"
            },
            {
              "id" => "5ea90537-033f-51e7-8f4a-d81a97039d8c@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "18-references"
            }
          ],
          "slug" => "18-work-and-the-economy"
        },
        {
          "id" => "9bc013c6-85d5-5483-8888-763df92d1b26@247752b",
          "title" =>
           "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>19</span>\n" +
           "    <span class=\"os-divider\"> </span>\n" +
           "    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Health and Medicine</span>",
          "toc_type" => "chapter",
          "contents" => [
            {
              "id" => "5f90d10f-2f6a-486c-86d4-893653b26b83@",
              "title" =>
               "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Health and Medicine</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "intro",
              "slug" => "19-introduction-to-health-and-medicine"
            },
            {
              "id" => "e31c5006-5e21-43fc-b070-c5347066cd96@",
              "title" =>
               "<span class=\"os-number\">19.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Social Construction of Health</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "19-1-the-social-construction-of-health"
            },
            {
              "id" => "d1ef539d-3612-4154-b787-6835fe93703b@",
              "title" =>
               "<span class=\"os-number\">19.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Global Health</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "19-2-global-health"
            },
            {
              "id" => "f3a2b187-e44d-4a5f-af59-ee4bcd39046f@",
              "title" =>
               "<span class=\"os-number\">19.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Health in the United States</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "19-3-health-in-the-united-states"
            },
            {
              "id" => "86d65916-f669-4a65-9187-15d83e2d1689@",
              "title" =>
               "<span class=\"os-number\">19.4</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Comparative Health and Medicine</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "19-4-comparative-health-and-medicine"
            },
            {
              "id" => "54923470-ad35-40ef-b09c-da89b0e19da5@",
              "title" =>
               "<span class=\"os-number\">19.5</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Theoretical Perspectives on Health and Medicine</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "19-5-theoretical-perspectives-on-health-and-medicine"
            },
            {
              "id" => "d88185c1-db86-5389-975a-77f5d1e2c4d9@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "19-key-terms"
            },
            {
              "id" => "e5d863ee-74f9-5975-90f8-4636b87dbf1b@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "19-section-summary"
            },
            {
              "id" => "981cfc29-bbb3-5e96-96e6-ca5c7174e678@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "19-section-quiz"
            },
            {
              "id" => "03b7607c-ee84-5ff1-bca2-de3b05df710c@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "19-short-answer"
            },
            {
              "id" => "ec196185-0f4b-538d-8dea-ab888976e35e@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "19-further-research"
            },
            {
              "id" => "52707f50-92d9-54c7-a635-63b37829f17c@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "19-references"
            }
          ],
          "slug" => "19-health-and-medicine"
        },
        {
          "id" => "21a970b1-6434-508d-bb9c-0aceab73a87a@247752b",
          "title" =>
           "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>20</span>\n" +
           "    <span class=\"os-divider\"> </span>\n" +
           "    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Population, Urbanization, and the Environment</span>",
          "toc_type" => "chapter",
          "contents" => [
            {
              "id" => "8803c7d4-c848-4b4e-a743-82f7477eb764@",
              "title" =>
               "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Population, Urbanization, and the Environment</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "intro",
              "slug" => "20-introduction-to-population-urbanization-and-the-environment"
            },
            {
              "id" => "2cf134f9-f88e-4590-8c33-404ead13ab83@",
              "title" =>
               "<span class=\"os-number\">20.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Demography and Population</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "20-1-demography-and-population"
            },
            {
              "id" => "4c117289-4d19-4892-82dd-c0e820ea9041@",
              "title" =>
               "<span class=\"os-number\">20.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Urbanization</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "20-2-urbanization"
            },
            {
              "id" => "a9c17e87-c269-4cd2-b540-aaf6cc273dbf@",
              "title" =>
               "<span class=\"os-number\">20.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">The Environment and Society</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "20-3-the-environment-and-society"
            },
            {
              "id" => "62697181-64c2-54a4-a557-9b7bd96f461c@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "20-key-terms"
            },
            {
              "id" => "7788b646-eccc-5e37-82ea-936eb32d87e4@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "20-section-summary"
            },
            {
              "id" => "0123e588-6856-558c-bf33-e6697299568c@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "20-section-quiz"
            },
            {
              "id" => "253e7ab7-491c-5ce1-ab8a-ea36a97a74c2@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "20-short-answer"
            },
            {
              "id" => "b5efbc22-ba7f-5de3-a167-acca92e01ac1@247752b",
              "title" => "<span class=\"os-text\">Further Research</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "20-further-research"
            },
            {
              "id" => "73d65c29-d568-58bd-89e0-03117acdb9b2@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "20-references"
            }
          ],
          "slug" => "20-population-urbanization-and-the-environment"
        },
        {
          "id" => "6c1c6896-f686-52b5-aa95-43c9b662166b@247752b",
          "title" =>
           "<span class=\"os-number\"><span class=\"os-part-text\">Chapter </span>21</span>\n" +
           "    <span class=\"os-divider\"> </span>\n" +
           "    <span class=\"os-text\" data-type=\"\" itemprop=\"\">Social Movements and Social Change</span>",
          "toc_type" => "chapter",
          "contents" => [
            {
              "id" => "31d1b1ea-ca56-4379-af73-b08eef4165ab@",
              "title" =>
               "<span data-type=\"\" itemprop=\"\" class=\"os-text\">Introduction to Social Movements and Social Change</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "intro",
              "slug" => "21-introduction-to-social-movements-and-social-change"
            },
            {
              "id" => "21126f9c-6b12-4860-a396-01a3ba24393e@",
              "title" =>
               "<span class=\"os-number\">21.1</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Collective Behavior</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "21-1-collective-behavior"
            },
            {
              "id" => "cea139cd-98de-4841-91e6-abcb0baa92da@",
              "title" =>
               "<span class=\"os-number\">21.2</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Social Movements</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "21-2-social-movements"
            },
            {
              "id" => "be2e1e07-67a1-469b-b17c-109fda35d510@",
              "title" =>
               "<span class=\"os-number\">21.3</span><span class=\"os-divider\"> </span><span data-type=\"\" itemprop=\"\" class=\"os-text\">Social Change</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "numbered-section",
              "slug" => "21-3-social-change"
            },
            {
              "id" => "816c3585-f399-5dd4-b14c-fd6d2b32b7e0@247752b",
              "title" => "<span class=\"os-text\">Key Terms</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "21-key-terms"
            },
            {
              "id" => "2e22c33f-e4fd-592f-bca4-c6396e64c42c@247752b",
              "title" => "<span class=\"os-text\">Section Summary</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "21-section-summary"
            },
            {
              "id" => "977ba877-734c-599f-84cf-83d345f0ed27@247752b",
              "title" => "<span class=\"os-text\">Section Quiz</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "21-section-quiz"
            },
            {
              "id" => "fa660f0f-bd7c-596e-a16a-af7a847bbd34@247752b",
              "title" => "<span class=\"os-text\">Short Answer</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "21-short-answer"
            },
            {
              "id" => "db5b4f91-0614-5937-a7af-a63c79980444@247752b",
              "title" => "<span class=\"os-text\">References</span>",
              "toc_type" => "book-content",
              "toc_target_type" => "composite-page",
              "slug" => "21-references"
            }
          ],
          "slug" => "21-social-movements-and-social-change"
        },
        {
          "id" => "ee970b62-d1a3-526c-8c4e-cb04346efdbb@247752b",
          "title" => "<span class=\"os-text\">Index</span>",
          "toc_type" => "book-content",
          "toc_target_type" => "index",
          "slug" => "index"
        }
      ]
    end
  end
end
