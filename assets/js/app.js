// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket, Presence } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
import Alpine from "alpinejs";
import moment from "moment-timezone";
import AirDatepicker from "air-datepicker";
import airdatepickerLocaleEn from "air-datepicker/locale/en";
import airdatepickerLocaleFr from "air-datepicker/locale/fr";
import airdatepickerLocaleDe from "air-datepicker/locale/de";
import airdatepickerLocaleEs from "air-datepicker/locale/es";
import airdatepickerLocaleNl from "air-datepicker/locale/nl";
import airdatepickerLocaleIt from "air-datepicker/locale/it";
import airdatepickerLocaleHu from "air-datepicker/locale/hu";
import "moment/locale/de";
import "moment/locale/fr";
import "moment/locale/es";
import "moment/locale/nl";
import "moment/locale/it";
import "moment/locale/hu";
import "moment/locale/lv";
import QRCodeStyling from "qr-code-styling";
import { Presenter } from "./presenter";
import { Manager } from "./manager";
import { AudioCapture } from "./audio_capture";
import Split from "split-grid";
import CustomHooks from "./hooks";
import "./admin-charts.js";
window.moment = moment;

// Get supported locales from backend configuration or fallback to default list
const supportedLocales = window.claperConfig?.supportedLocales || [
  "en",
  "fr",
  "de",
  "es",
  "nl",
  "it",
  "hu",
  "lv",
];

const airdatePickrSupportedLocales = window.claperConfig?.supportedLocales || [
  "en",
  "fr",
  "de",
  "es",
  "nl",
  "it",
  "hu",
];

var locale =
  document.querySelector("html").getAttribute("lang") ||
  navigator.language.split("-")[0];

var airdatepickrLocale = locale;

if (!supportedLocales.includes(locale)) {
  locale = "en";
}
if (!airdatePickrSupportedLocales.includes(airdatepickrLocale)) {
  airdatepickrLocale = "en";
}

window.moment.locale("en");
window.moment.locale(locale);
window.Alpine = Alpine;
Alpine.start();

let airdatePickrLocales = {
  en: airdatepickerLocaleEn,
  fr: airdatepickerLocaleFr,
  de: airdatepickerLocaleDe,
  es: airdatepickerLocaleEs,
  nl: airdatepickerLocaleNl,
  it: airdatepickerLocaleIt,
  hu: airdatepickerLocaleHu,
};
let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let Hooks = {};

Hooks.EmbeddedBanner = {
  mounted() {
    if (window !== window.parent) {
      this.el.classList.remove("hidden");
    }
  },
  updated() {
    if (window !== window.parent) {
      this.el.classList.remove("hidden");
    }
  },
};

Hooks.Split = {
  mounted() {
    const type = this.el.dataset.type;
    const id = this.el.id;
    const gutter = this.el.dataset.gutter;
    const forceLayout = this.el.classList.contains("grid-cols-[1fr]");
    const columnSlitValue =
      localStorage.getItem(`column-split-${id}`) || "1fr 10px 1fr";
    const rowSlitValue =
      localStorage.getItem(`row-split-${id}`) || "0.5fr 10px 1fr";

    if (type === "column") {
      this.columnSplit = Split({
        columnGutters: [
          {
            track: 1,
            element: this.el.querySelector(gutter),
          },
        ],
        onDragEnd: () => {
          const currentPosition = this.el.style["grid-template-columns"];
          localStorage.setItem(`column-split-${id}`, currentPosition);
        },
      });
      if (!forceLayout) {
        this.el.style["grid-template-columns"] = columnSlitValue;
      }
    } else {
      this.rowSplit = Split({
        rowGutters: [
          {
            track: 1,
            element: this.el.querySelector(gutter),
          },
        ],
        onDragEnd: () => {
          const value = this.el.style["grid-template-rows"];
          localStorage.setItem(`row-split-${id}`, value);
        },
      });
      if (!forceLayout) {
        this.el.style["grid-template-rows"] = rowSlitValue;
      }
    }
  },
  updated() {
    const id = this.el.id;
    const forceLayout = this.el.classList.contains("grid-cols-[1fr]");
    if (forceLayout) {
      return;
    }

    if (this.columnSplit) {
      this.columnSplit.destroy();
    }
    if (this.rowSplit) {
      this.rowSplit.destroy();
    }

    this.mounted();
  },
  destroyed() {
    if (this.columnSplit) {
      this.columnSplit.destroy();
    }
    if (this.rowSplit) {
      this.rowSplit.destroy();
    }
  },
};

Hooks.Scroll = {
  mounted() {
    if (this.el.dataset.postsNb > 4)
      window.scrollTo({
        top: document.querySelector(this.el.dataset.target).scrollHeight,
        behavior: "smooth",
      });
    this.handleEvent("scroll", () => {});
  },
  updated() {
    let t = document.querySelector(this.el.dataset.target);
    if (
      this.el.childElementCount > 4 &&
      window.scrollY + window.innerHeight >= t.offsetHeight - 300
    ) {
      window.scrollTo({ top: t.scrollHeight, behavior: "smooth" });
    }
  },
};

Hooks.ScrollIntoDiv = {
  mounted() {
    let useParent = this.el.dataset.useParent === "true";
    this.scrollElement =
      this.el.dataset.useParent === "true" ? this.el.parentElement : this.el;
    this.checkIfAtBottom();
    this.scrollToBottom(true);
    this.handleEvent("scroll", () => this.scrollToBottom());
    this.scrollElement.addEventListener("scroll", () => this.checkIfAtBottom());
  },
  checkIfAtBottom() {
    this.isAtBottom =
      this.scrollElement.scrollHeight -
        this.scrollElement.scrollTop -
        this.scrollElement.clientHeight <=
      30;
  },
  scrollToBottom(force = false) {
    if (force || this.isAtBottom) {
      this.scrollElement.scrollTo({
        top: this.scrollElement.scrollHeight,
        behavior: "smooth",
      });
    }
  },
  updated() {
    this.scrollToBottom();
  },
  destroyed() {
    this.scrollElement.removeEventListener("scroll", () =>
      this.checkIfAtBottom(),
    );
  },
};

Hooks.NicknamePicker = {
  mounted() {
    let currentNickname = localStorage.getItem("nickname") || "";
    if (currentNickname.length > 0) {
      this.pushEvent("set-nickname", { nickname: currentNickname });
    }

    this.el.addEventListener("click", (e) => this.clicked(e));
  },
  reconnected() {
    let currentNickname = localStorage.getItem("nickname") || "";
    if (currentNickname.length > 0) {
      this.pushEvent("set-nickname", { nickname: currentNickname });
    }
  },
  destroyed() {
    this.el.removeEventListener("click", (e) => this.clicked(e));
  },
  clicked(e) {
    let nickname = prompt(
      this.el.dataset.prompt,
      localStorage.getItem("nickname") || "",
    );

    if (nickname) {
      localStorage.setItem("nickname", nickname);
      this.pushEvent("set-nickname", { nickname: nickname });
    }
  },
};

Hooks.EmptyNickname = {
  mounted() {
    this.el.addEventListener("click", (e) => this.clicked(e));
  },
  destroyed() {
    this.el.removeEventListener("click", (e) => this.clicked(e));
  },
  clicked(e) {
    localStorage.removeItem("nickname");
  },
};

Hooks.SearchableSelect = {
  mounted() {
    this.handleEvent("update_hidden_field", (payload) => {
      if (payload.id === this.el.id) {
        this.el.value = payload.value;
        // Trigger a change event to update the form
        const event = new Event('input', { bubbles: true });
        this.el.dispatchEvent(event);
      }
    });
  }
};

Hooks.PostForm = {
  onPress(e, submitBtn, TA) {
    if (e.key == "Enter" && !e.shiftKey) {
      e.preventDefault();
      submitBtn.click();
    } else {
      if (TA.value.length > 0 && TA.value.length < 256) {
        submitBtn.classList.remove("opacity-50");
        submitBtn.classList.add("opacity-100");
        submitBtn.disabled = false;
      } else {
        submitBtn.classList.add("opacity-50");
        submitBtn.classList.remove("opacity-100");
        submitBtn.disabled = true;
      }
    }
  },
  onSubmit(e, TA) {
    e.preventDefault();
    document.getElementById("hiddenSubmit").click();
    TA.value = "";
  },
  mounted() {
    setTimeout(() => {
      const submitBtn = document.getElementById("submitBtn");
      const TA = document.getElementById("postFormTA");
      if (submitBtn && TA) {
        submitBtn.addEventListener("click", (e) => this.onSubmit(e, TA));
        TA.addEventListener("keydown", (e) => this.onPress(e, submitBtn, TA));
      }
    }, 500);

    // set nickname if present
    let nickname = this.el.dataset.nickname;
    if (nickname) {
      localStorage.setItem("nickname", nickname);
    }
  },
  updated() {
    const submitBtn = document.getElementById("submitBtn");
    const TA = document.getElementById("postFormTA");
    if (TA.value.length > 0 && TA.value.length < 256) {
      submitBtn.classList.remove("opacity-50");
      submitBtn.classList.add("opacity-100");
      submitBtn.disabled = false;
    } else {
      submitBtn.classList.add("opacity-50");
      submitBtn.classList.remove("opacity-100");
      submitBtn.disabled = true;
    }
  },
  destroyed() {
    const submitBtn = document.getElementById("submitBtn");
    const TA = document.getElementById("postFormTA");
    if (submitBtn && TA) {
      TA.removeEventListener("keydown", (e) => this.onPress(e, submitBtn, TA));
      submitBtn.removeEventListener("click", (e) => this.onSubmit(e, TA));
    }
  },
};

Hooks.CalendarLocalDate = {
  mounted() {
    this.el.innerHTML = moment.utc(this.el.dataset.date).local().calendar();
  },
  updated() {
    this.el.innerHTML = moment.utc(this.el.dataset.date).local().calendar();
  },
};
Hooks.Pickr = {
  mounted() {
    const localTime = this.el.querySelector("input[type=text]");
    const utcTime = this.el.querySelector("input[type=hidden]");
    localTime.value = moment
      .utc(utcTime.value)
      .local()
      .format("DD-MM-YYYY HH:mm");
    this.pickr = new AirDatepicker(localTime, {
      dateFormat: "dd-MM-yyyy",
      timepicker: true,
      minutesStep: 5,
      minDate: moment(),
      timeFormat: "HH:mm",
      selectedDates: [moment(localTime.value, "DD-MM-YYYY HH:mm").toDate()],
      onSelect: ({ date }) => {
        const utc = moment(date).utc().format("YYYY-MM-DDTHH:mm:ss");
        utcTime.value = utc;
      },
      locale: airdatePickrLocales[airdatepickrLocale] || airdatePickrLocales["en"],
    });
  },
  updated() {},
  destroyed() {
    if (this.pickr) this.pickr.destroy();
  },
};
Hooks.UpdateAttendees = {
  mounted() {
    this.handleEvent("update-attendees", ({ count }) => {
      this.el.textContent = count;

      const labelId = this.el.dataset.labelId;
      const label = labelId ? document.getElementById(labelId) : null;

      if (label) {
        label.textContent = count > 1 ? this.el.dataset.plural : this.el.dataset.singular;
      }
    });
  },
};
Hooks.Presenter = {
  mounted() {
    this.presenter = new Presenter(this);
    this.presenter.init();
  },
  updated() {
    this.presenter.update();
  },
};
Hooks.Manager = {
  mounted() {
    this.manager = new Manager(this);
    this.manager.init();
  },
  updated() {
    this.manager.update();
  },
};
Hooks.SlideSortable = {
  mounted() {
    this.from = null;

    this.el.addEventListener("dragstart", (e) => {
      const item = e.target.closest("[data-index]");
      if (!item) return;
      this.from = parseInt(item.dataset.index);
      e.dataTransfer.effectAllowed = "move";
      e.dataTransfer.setData("text/plain", item.dataset.index);
      setTimeout(() => item.classList.add("opacity-40"), 0);
    });

    this.el.addEventListener("dragover", (e) => {
      if (this.from === null) return;
      e.preventDefault();
      e.dataTransfer.dropEffect = "move";
      const item = e.target.closest("[data-index]");
      this.clearDropTarget();
      if (item && parseInt(item.dataset.index) !== this.from) {
        item.classList.add("ring-2", "ring-primary-500");
      }
    });

    this.el.addEventListener("drop", (e) => {
      e.preventDefault();
      const item = e.target.closest("[data-index]");
      if (item && this.from !== null) {
        const to = parseInt(item.dataset.index);
        if (to !== this.from) {
          this.pushEvent("reorder-slides", { from: this.from, to: to });
        }
      }
      this.reset();
    });

    this.el.addEventListener("dragend", () => this.reset());
  },
  clearDropTarget() {
    this.el
      .querySelectorAll("[data-index]")
      .forEach((n) => n.classList.remove("ring-2", "ring-primary-500"));
  },
  reset() {
    this.from = null;
    this.clearDropTarget();
    this.el
      .querySelectorAll("[data-index]")
      .forEach((n) => n.classList.remove("opacity-40"));
  },
};
Hooks.OpenPresenter = {
  open(e) {
    e.preventDefault();
    window.open(
      this.el.dataset.url,
      "newwindow",
      "width=" + window.screen.width + ",height=" + window.screen.height,
    );
  },
  mounted() {
    this.el.addEventListener("click", (e) => this.open(e));
  },
  updated() {
    this.el.removeEventListener("click", (e) => this.open(e));
    this.el.addEventListener("click", (e) => this.open(e));
  },
  destroyed() {
    this.el.removeEventListener("click", (e) => this.open(e));
  },
};
Hooks.GlobalReacts = {
  svgCache: {},

  mounted() {
    this.preloadSVGs();
    this.handleEvent("global-react", (data) => {
      const svgContent = this.svgCache[data.type];
      if (svgContent) {
        const container = document.createElement("div");
        container.innerHTML = svgContent;
        const svgElement = container.firstChild;
        svgElement.classList.add(
          "react-animation",
          "absolute",
          "transform",
          "opacity-0",
        );
        svgElement.classList.add(...this.el.className.split(" "));
        this.el.appendChild(svgElement);
      }
    });
    this.handleEvent("reset-global-react", (data) => {
      this.el.innerHTML = "";
    });
  },

  preloadSVGs() {
    const svgTypes = ["heart", "hundred", "clap", "raisehand"];
    svgTypes.forEach((type) => {
      fetch(`/images/icons/${type}.svg`)
        .then((response) => response.text())
        .then((svgContent) => {
          this.svgCache[type] = svgContent;
        })
        .catch((error) =>
          console.error(`Error loading SVG for ${type}:`, error),
        );
    });
  },
};
Hooks.WelcomeEarly = {
  mounted() {
    if (localStorage.getItem("welcome-early") !== "false") {
      this.el.style.display = "block";
      this.el.children[0].addEventListener("click", (e) => {
        e.preventDefault();
        localStorage.setItem("welcome-early", "false");
        this.el.style.display = "none";
      });
    }
  },
  destroyed() {
    this.el.children[0].removeEventListener("click", (e) => {
      e.preventDefault();
      localStorage.setItem("welcome-early", "false");
      this.el.style.display = "none";
    });
  },
};
Hooks.ClickFeedback = {
  clicked(e) {
    this.el.className = "animate__animated animate__rubberBand animate__faster";
    setTimeout(() => {
      this.el.className = "";
    }, 500);
  },
  mounted() {
    this.el.addEventListener("click", (e) => this.clicked(e));
  },
  destroyed() {
    this.el.removeEventListener("click", (e) => this.clicked(e));
  },
};
Hooks.QRCode = {
  draw() {
    var url = this.el.dataset.code
      ? window.location.protocol +
        "//" +
        window.location.host +
        "/e/" +
        this.el.dataset.code
      : window.location.href;
    var size = this.el.dataset.dynamic
      ? document.documentElement.clientWidth * 0.25
      : parseInt(this.el.dataset.size || "240", 10);

    if (this.el.dataset.dynamic) {
      this.el.style.width = document.documentElement.clientWidth * 0.27 + "px";
      this.el.style.height = document.documentElement.clientWidth * 0.27 + "px";
    }

    if (this.qrCode == null) {
      this.qrCode = new QRCodeStyling({
        width: size,
        height: size,
        margin: 0,
        data: url,
        cornersSquareOptions: {
          type: "square",
        },
        dotsOptions: {
          type: "square",
          color: "#000000",
        },
        backgroundOptions: {
          color: "#ffffff",
        },
        imageOptions: {
          crossOrigin: "anonymous",
          imageSize: 0.6,
          margin: 10,
        },
      });
      this.qrCode.append(this.el);
    } else {
      this.qrCode.update({
        width: size,
        height: size,
      });
    }
  },
  mounted() {
    window.addEventListener("resize", this.draw.bind(this));
    this.draw();
    if (this.el.dataset.getUrl) {
      setTimeout(() => {
        var dataURL = this.qrCode._canvas.toDataURL();
        document.getElementById("qr-url").value = dataURL;
      }, 500);
    }
  },
  updated() {},
  destroyed() {},
};

Hooks.TicketTilt = {
  // Writes tilt/glare values as CSS vars on <html> rather than inline
  // styles on the ticket: the countdown patches this subtree every
  // second and morphdom would wipe inline styles mid-animation.
  mounted() {
    if (
      !window.matchMedia("(pointer: fine)").matches ||
      window.matchMedia("(prefers-reduced-motion: reduce)").matches
    ) {
      return;
    }

    this.root = document.documentElement;
    this.frame = null;

    this.onMove = (e) => {
      this.lastEvent = e;
      if (this.frame) return;
      this.frame = requestAnimationFrame(() => {
        this.frame = null;
        const r = this.el.getBoundingClientRect();
        const x = this.lastEvent.clientX - r.left;
        const y = this.lastEvent.clientY - r.top;
        const px = x / r.width - 0.5;
        const py = y / r.height - 0.5;
        this.root.style.setProperty("--tilt-ry", (px * 10).toFixed(2) + "deg");
        this.root.style.setProperty("--tilt-rx", (py * -8).toFixed(2) + "deg");
        this.root.style.setProperty("--glare-x", x.toFixed(0) + "px");
        this.root.style.setProperty("--glare-y", y.toFixed(0) + "px");
        this.root.style.setProperty("--glare-o", "1");
      });
    };

    this.onLeave = () => {
      if (this.frame) {
        cancelAnimationFrame(this.frame);
        this.frame = null;
      }
      this.root.style.setProperty("--tilt-rx", "0deg");
      this.root.style.setProperty("--tilt-ry", "0deg");
      this.root.style.setProperty("--glare-o", "0");
    };

    this.el.addEventListener("mousemove", this.onMove);
    this.el.addEventListener("mouseleave", this.onLeave);
  },
  destroyed() {
    if (!this.onMove) return;
    this.el.removeEventListener("mousemove", this.onMove);
    this.el.removeEventListener("mouseleave", this.onLeave);
    if (this.frame) cancelAnimationFrame(this.frame);
    ["--tilt-rx", "--tilt-ry", "--glare-x", "--glare-y", "--glare-o"].forEach(
      (p) => document.documentElement.style.removeProperty(p),
    );
  },
};

Hooks.Dropdown = {
  mounted() {
    this.el.addEventListener("click", (e) => {
      this.el.classList.toggle("hidden");
    });
  },
};

Hooks.AdminChart = {
  mounted() {
    const chartType = this.el.dataset.chartType;
    const canvasId = this.el.querySelector('canvas').id;
    const data = JSON.parse(this.el.dataset.chartData);
    
    if (chartType === 'users') {
      window.AdminCharts.createUsersChart(canvasId, data);
    } else if (chartType === 'events') {
      window.AdminCharts.createEventsChart(canvasId, data);
    }
    
    this.handleEvent("update_chart", (newData) => {
      window.AdminCharts.updateChart(canvasId, newData);
    });
  },
  
  updated() {
    const chartType = this.el.dataset.chartType;
    const canvasId = this.el.querySelector('canvas').id;
    const data = JSON.parse(this.el.dataset.chartData);
    
    if (chartType === 'users') {
      window.AdminCharts.createUsersChart(canvasId, data);
    } else if (chartType === 'events') {
      window.AdminCharts.createEventsChart(canvasId, data);
    }
  },
  
  destroyed() {
    const canvasId = this.el.querySelector('canvas').id;
    window.AdminCharts.destroyChart(canvasId);
  }
};

Hooks.CSVDownloader = {
  mounted() {
    this.handleEvent("download_csv", ({ filename, content }) => {
      const blob = new Blob([content], { type: 'text/csv' });
      const url = window.URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = filename;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      window.URL.revokeObjectURL(url);
    });
  }
};

Hooks.TranscriptionCapture = {
  mounted() {
    this.audioCapture = null;
    this.handleEvent("transcription-state", ({ enabled }) => {
      if (enabled) {
        this.startCapture();
      } else {
        this.stopCapture();
      }
    });
  },
  startCapture() {
    if (this.audioCapture) return;
    const eventUuid = this.el.dataset.eventUuid;
    const audioToken = this.el.dataset.audioToken;
    const savedDeviceId = localStorage.getItem(`mic-${eventUuid}`);
    this.audioCapture = new AudioCapture(eventUuid, audioToken);
    this.audioCapture.start(savedDeviceId || null);
  },
  stopCapture() {
    if (this.audioCapture) {
      this.audioCapture.stop();
      this.audioCapture = null;
    }
  },
  destroyed() {
    this.stopCapture();
  },
};

Hooks.MicSelector = {
  mounted() {
    if (!navigator.mediaDevices) {
      console.warn("MicSelector: mediaDevices unavailable (requires HTTPS)");
      return;
    }
    this.populateDevices();
    navigator.mediaDevices.addEventListener("devicechange", () =>
      this.populateDevices(),
    );
  },
  async populateDevices() {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      stream.getTracks().forEach((track) => track.stop());
    } catch (e) {
      // Permission denied - populate with what we can
    }
    const devices = await navigator.mediaDevices.enumerateDevices();
    const audioInputs = devices.filter((d) => d.kind === "audioinput");
    const select = this.el;
    select.innerHTML = "";
    audioInputs.forEach((device) => {
      const opt = document.createElement("option");
      opt.value = device.deviceId;
      opt.textContent =
        device.label || `Microphone ${device.deviceId.slice(0, 8)}`;
      select.appendChild(opt);
    });
    const saved = localStorage.getItem(
      `mic-${this.el.dataset.eventUuid}`,
    );
    if (saved) select.value = saved;
    select.addEventListener("change", () => {
      localStorage.setItem(
        `mic-${this.el.dataset.eventUuid}`,
        select.value,
      );
    });
  },
};

// Merge our custom hooks with the existing hooks
Object.assign(Hooks, CustomHooks);

let liveSocket = new LiveSocket("/live", Socket, {
  params: {
    _csrf_token: csrfToken,
    tz: Intl.DateTimeFormat().resolvedOptions().timeZone,
    host: window.location.host,
  },
  hooks: Hooks,
  dom: {
    onBeforeElUpdated(from, to) {
      if (from._x_dataStack) {
        window.Alpine.clone(from, to);
        window.Alpine.initTree(to);
      }
    },
  },
});

// Show progress bar on live navigation and form submits
let topBarScheduled = undefined;
topbar.config({ barColors: { 0: "#fff" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (info) => {
  if (!topBarScheduled) {
    topBarScheduled = setTimeout(() => topbar.show(), 500);
  }
});
window.addEventListener("phx:page-loading-stop", (info) => {
  clearTimeout(topBarScheduled);
  topBarScheduled = undefined;
  topbar.hide();
});

const onlineUserTemplate = function (user) {
  return `
    <div id="online-user">
      <strong class="text-secondary">aaa</strong>
    </div>
  `;
};

let presences = {};
liveSocket.on("presence_state", (state) => {
  presences = Presence.syncState(presences, state);
});

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
