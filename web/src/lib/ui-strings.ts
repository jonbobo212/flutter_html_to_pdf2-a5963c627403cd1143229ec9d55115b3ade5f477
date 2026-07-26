/**
 * Template chrome strings (nav labels, form labels, badge) in the five locale
 * codes the platform serves: uz (Uzbek latin), ru, en, tg (Tajik), ky (Kyrgyz).
 * Partner CONTENT is trilingual jsonb in the DB — these are only the fixed UI
 * strings around it. Every new key must be added to all five locales.
 */
export const UI = {
  uz: {
    home: "Bosh sahifa",
    news: "Yangiliklar",
    achievements: "Yutuqlar",
    about: "Biz haqimizda",
    admissions: "Qabul",
    contact: "Aloqa",
    readMore: "Batafsil",
    contactHeading: "Biz bilan bog‘laning",
    formName: "Ismingiz",
    formPhone: "Telefon raqamingiz",
    formMessage: "Xabar (ixtiyoriy)",
    formSubmit: "Yuborish",
    formThanks: "Rahmat! Tez orada siz bilan bog‘lanamiz.",
    formError: "Yuborilmadi. Iltimos, qayta urinib ko‘ring.",
    poweredBy: "Powered by Aspira",
  },
  ru: {
    home: "Главная",
    news: "Новости",
    achievements: "Достижения",
    about: "О нас",
    admissions: "Приём",
    contact: "Контакты",
    readMore: "Подробнее",
    contactHeading: "Свяжитесь с нами",
    formName: "Ваше имя",
    formPhone: "Ваш телефон",
    formMessage: "Сообщение (необязательно)",
    formSubmit: "Отправить",
    formThanks: "Спасибо! Мы скоро свяжемся с вами.",
    formError: "Не удалось отправить. Пожалуйста, попробуйте ещё раз.",
    poweredBy: "Powered by Aspira",
  },
  en: {
    home: "Home",
    news: "News",
    achievements: "Achievements",
    about: "About",
    admissions: "Admissions",
    contact: "Contact",
    readMore: "Read more",
    contactHeading: "Get in touch",
    formName: "Your name",
    formPhone: "Your phone",
    formMessage: "Message (optional)",
    formSubmit: "Send",
    formThanks: "Thank you! We will be in touch soon.",
    formError: "Could not send. Please try again.",
    poweredBy: "Powered by Aspira",
  },
  tg: {
    home: "Саҳифаи асосӣ",
    news: "Хабарҳо",
    achievements: "Дастовардҳо",
    about: "Дар бораи мо",
    admissions: "Қабул",
    contact: "Тамос",
    readMore: "Муфассал",
    contactHeading: "Бо мо дар тамос шавед",
    formName: "Номи шумо",
    formPhone: "Телефони шумо",
    formMessage: "Паём (ихтиёрӣ)",
    formSubmit: "Фиристодан",
    formThanks: "Ташаккур! Ба зудӣ бо шумо тамос мегирем.",
    formError: "Фиристода нашуд. Лутфан, боз кӯшиш кунед.",
    poweredBy: "Powered by Aspira",
  },
  ky: {
    home: "Башкы бет",
    news: "Жаңылыктар",
    achievements: "Жетишкендиктер",
    about: "Биз жөнүндө",
    admissions: "Кабыл алуу",
    contact: "Байланыш",
    readMore: "Толугураак",
    contactHeading: "Биз менен байланышыңыз",
    formName: "Атыңыз",
    formPhone: "Телефонуңуз",
    formMessage: "Билдирүү (милдеттүү эмес)",
    formSubmit: "Жөнөтүү",
    formThanks: "Рахмат! Жакында сиз менен байланышабыз.",
    formError: "Жөнөтүлгөн жок. Кайра аракет кылып көрүңүз.",
    poweredBy: "Powered by Aspira",
  },
} as const;

export type UiLocale = keyof typeof UI;

export function ui(locale: string) {
  return UI[(locale in UI ? locale : "en") as UiLocale];
}

export const LOCALE_NAMES: Record<string, string> = {
  uz: "O‘zbekcha",
  ru: "Русский",
  en: "English",
  tg: "Тоҷикӣ",
  ky: "Кыргызча",
};
