"use client";

import Link from 'next/link';
import { useTranslations } from 'next-intl';

import { getCookie } from '@utils/core';

import ClientAddress from './clientAddress';
import ShoppingCartComponent from './shoppingCartComponent';
import SummarySideBar from './summarySideBar';
import PriceSummary from './summarySideBar/priceSummary';
import { IProps } from './type';

export default function ShoppingCartTemplate({ ...props }: IProps) {
  const { locale } = props;
  const t = useTranslations('shoppingCart');
  const isAuthenticated = Boolean(getCookie("candySession"));

  return (
    <>
      <main className="pt-4 pb-16 md:pb-24 text-ink luca-container">
        <div className="items-start gap-8 lg:gap-14 grid grid-cols-1 lg:grid-cols-[minmax(0,1fr)_420px]">
          {/* Cart lines and delivery address */}
          <div className="flex flex-col gap-8 min-w-0">
            <ShoppingCartComponent locale={locale} />
            {isAuthenticated && <ClientAddress />}
          </div>

          {/* Order summary */}
          {isAuthenticated ? <SummarySideBar locale={locale} /> : (
            <aside className="flex flex-col gap-4 bg-white p-6 border luca-line">
              <h2 className="luca-h3">{t('shoppingCartSummary')}</h2>
              <PriceSummary />
              <Link className="store-btn store-btn-primary" href={`/${locale}/register?redirect=/${locale}/shoppingCart`}>
                {t('signInToCheckout')}
              </Link>
            </aside>
          )}
        </div>
      </main>
    </>
  );
}
