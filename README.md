[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/ClaperCo/Claper">
    <img src="priv/static/images/logo.png" alt="Logo" >
  </a>

  <h3 align="center">Claper</h3>

  <p align="center">
    The ultimate tool to interact with your audience.
    <br />
    <a href="https://docs.claper.co"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/ClaperCo/Claper/issues">Report Bug</a>
    ·
    <a href="https://github.com/ClaperCo/Claper/issues">Request Feature</a>
  </p>
</div>

[![Product Name Screen Shot][product-screenshot]](https://claper.co)

Claper turns your presentations into an interactive, engaging and exciting experience.

Claper has a two-sided mission:

- The first one is to help these people presenting an idea or a message by giving them the opportunity to make their presentation unique and to have real-time feedback from their audience.
- The second one is to help each participant to take their place, to be an actor in the presentation, in the meeting and to feel important and useful.

Supported languages: 🇬🇧 English, 🇫🇷 French, 🇩🇪 German, 🇪🇸 Spanish, 🇳🇱 Dutch, 🇮🇹 Italian, 🇭🇺 Hungarian, 🇱🇻 Latvian

### Built With

Claper is proudly powered by Phoenix and Elixir.

[![Phoenix][Phoenix]][Phoenix-url] [![Elixir][Elixir]][Elixir-url] [![Tailwind][Tailwind]][Tailwind-url]

### Our partners and sponsors

<a href="https://www.lmddc.lu/"><img src="priv/static/images/partners/lmddc.png" alt="LMDDC" height="50"></a>

## Documentation

You can find all the instructions and configuration in [the documentation](https://docs.claper.co/).

## CCFII Present operations

CCFII Present is the public fork at [ccfii-engineering/ccfii-present](https://github.com/ccfii-engineering/ccfii-present). Its upstream remains [ClaperCo/Claper](https://github.com/ClaperCo/Claper). To bring in upstream release tags before reviewing an upgrade, run:

```bash
git fetch upstream --tags
git log --oneline HEAD..upstream/main
```

The CCFII Present seal originates from `ccfii-web/public/images/ccfii-logo.png`. The deployment palette is maroon `#810E0E`, gold `#FAA739`, blue `#3567FF`, and dark neutrals `#1E1414` / `#120A0A`.

Verify a local change with:

```bash
npm --prefix assets ci
./with_env.sh mix assets.deploy
./with_env.sh mix format --check-formatted
./with_env.sh mix credo
# Ensure .env sets MIX_ENV=test before running the test suite.
./with_env.sh mix test
npx --yes yaml-lint .github/workflows/elixir.yml .github/workflows/docker-image.yml
```

Release tags use the immutable format `3.0.0-ccfii.2`. Pushing such a tag publishes the multi-architecture image `ghcr.io/ccfii-engineering/ccfii-present:3.0.0-ccfii.2`. Deploy that exact tag in Railway; do not use a mutable branch or `latest` image. After validation, explicitly dispatch the **CCFII Present container image** workflow with the immutable `image_tag` and `promote=true` to add the `production` tag to the same digest without rebuilding it.

To roll back, update Railway to `ghcr.io/claperco/claper:3.0.0`. CCFII Present remains an AGPLv3 fork: preserve the upstream Claper copyright, license notices, and visible/source attribution when distributing or operating modified versions.

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/amazing_feature`)
3. Commit your Changes (`git commit -m 'Add some amazing feature'`)
4. Push to the Branch (`git push origin feature/amazing_feature`)
5. Open a Pull Request on the `dev` branch

<!-- LICENSE -->

## License

Distributed under the AGPLv3 License. See `LICENSE.txt` for more information.

<!-- CONTACT -->

## Links

[![](https://img.shields.io/badge/ClaperCo/Claper-000000?style=for-the-badge&logo=Github&logoColor=white)](https://github.com/ClaperCo/Claper)

[![](https://img.shields.io/badge/Discord-5052db?style=for-the-badge&logo=Discord&logoColor=white)](https://discord.gg/M7ejVaC9gA)

[![](https://img.shields.io/badge//r/claper-ed491a?style=for-the-badge&logo=Reddit&logoColor=white)](https://reddit.com/r/claper)

[![](<https://img.shields.io/badge/Alex_Lion_(Founder)-000000?style=for-the-badge&logo=x&logoColor=white>)](https://x.com/alxlion_)

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[contributors-shield]: https://img.shields.io/github/contributors/ClaperCo/Claper.svg?style=for-the-badge
[contributors-url]: https://github.com/ClaperCo/Claper/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/ClaperCo/Claper.svg?style=for-the-badge
[forks-url]: https://github.com/ClaperCo/Claper/network/members
[stars-shield]: https://img.shields.io/github/stars/ClaperCo/Claper.svg?style=for-the-badge
[stars-url]: https://github.com/ClaperCo/Claper/stargazers
[issues-shield]: https://img.shields.io/github/issues/ClaperCo/Claper.svg?style=for-the-badge
[issues-url]: https://github.com/ClaperCo/Claper/issues
[license-shield]: https://img.shields.io/github/license/ClaperCo/Claper.svg?style=for-the-badge
[license-url]: https://github.com/ClaperCo/Claper/blob/master/LICENSE.txt
[product-screenshot]: /priv/static/images/preview.png
[Elixir]: https://img.shields.io/badge/elixir-4B275F?style=for-the-badge&logo=elixir&logoColor=white
[Elixir-url]: https://elixir-lang.org/
[Tailwind]: https://img.shields.io/badge/tailwind-06B6D4?style=for-the-badge&logo=tailwindcss&logoColor=white
[Tailwind-url]: https://tailwindcss.com/
[Phoenix]: https://img.shields.io/badge/phoenix-f35424?style=for-the-badge&logo=&logoColor=white
[Phoenix-url]: https://www.phoenixframework.org/
[lmddc-logo]: /priv/static/images/partners/lmddc.png
[pixilearn-logo]: /priv/static/images/partners/pixilearn.png
[uccs-logo]: /priv/static/images/partners/uccs.png
